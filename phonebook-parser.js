'use strict';

var fs = require('fs');
var http = require('http');

http.get('http://eventphone.de/guru2/phonebook?event=34C3&format=json', function (res) {
    var statusCode = res.statusCode;
    var contentType = res.headers['content-type'];

    var error = void 0;
    if (statusCode !== 200) {
        error = new Error('Request Failed.\n' + ('Status Code: ' + statusCode));
    } else if (!/^application\/json/.test(contentType)) {
        error = new Error('Invalid content-type.\n' + ('Expected application/json but received ' + contentType));
    }
    if (error) {
        console.log(error.message);
        // consume response data to free up memory
        res.resume();
        return;
    }

    res.setEncoding('utf8');
    var rawData = '';
    res.on('data', function (chunk) {
        return rawData += chunk;
    });
    res.on('end', function () {
        try {

            var parsedData = JSON.parse(rawData);
            parsedData.forEach(function (elem) {

                if (elem.extension >= 8000 || elem.extension < 2101) {
                    return;
                }

                if (elem.phone_type != 5) {
                    return;
                }

                fs.appendFile('/data/callees.txt', elem.extension + "\n", function (err) {});
            });
        } catch (e) {
            console.log(e.message);
        }
    });
}).on('error', function (e) {
    console.log('Got error: ' + e.message);
});
