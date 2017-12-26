FROM debian:jessie

RUN apt-get update \
  &&  apt-get -yqq install curl bzip2 build-essential libasound2-dev \
  &&  mkdir -p /usr/src && cd /usr/src \
  &&  curl -sf -o pjproject.tar.bz2 -L http://www.pjsip.org/release/2.5.5/pjproject-2.5.5.tar.bz2 \
  &&  tar -xvjf pjproject.tar.bz2 \
  &&  rm pjproject.tar.bz2 \
  &&  cd pjproject* \
  &&  ./configure \
  &&  make dep \
  &&  make \
  &&  cp pjsip-apps/bin/pjsua-*gnu /usr/bin/pjsua

RUN apt-get install -yqq pulseaudio
RUN apt-get install -yqq nodejs

COPY one.wav /data/one.wav
COPY rms.wav /data/rms.wav
COPY pjsua_one.cfg /data/pjsua_one.cfg
COPY pjsua_rms.cfg /data/pjsua_rms.cfg
COPY entrypoint.sh /entrypoint.sh
COPY phonebook-parser.js /phonebook-parser.js

CMD /entrypoint.sh

