FROM ubuntu:22.04

ARG SRCTAR=StripTest

#Install x86 support (optional)
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
RUN apt-get update && apt-get -y install make gcc-multilib

RUN mkdir -p /StripTest
WORKDIR /StripTest

ADD ${SRCTAR}.tar.gz /StripTest/
COPY ${SRCTAR}.sh /StripTest/RunTest.sh
COPY ${SRCTAR}.cmd /StripTest/RunTest.cmd
COPY BuildRS.sh /StripTest/BuildRS.sh
RUN chmod a+x /StripTest/RunTest.sh /StripTest/BuildRS.sh

VOLUME StripTest/bin

ENTRYPOINT [ "./RunTest.sh" ]
