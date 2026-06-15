#!/bin/bash
cd Docker_SD
GZIP=-9 tar czfv ../StripTestSD.tar.gz *
cd ../Docker_HD
GZIP=-9 tar czfv ../StripTestHD.tar.gz *
cd ..

docker build --build-arg SRCTAR="StripTestSD" -t "cwuensch/striptest:SD_neu" .
docker build --build-arg SRCTAR="StripTestHD" -t "cwuensch/striptest:HD_neu" .
docker build -f Dockerfile_universal -t "cwuensch/striptest:all" .

docker login docker.io
docker push cwuensch/striptest:SD_neu
docker push cwuensch/striptest:HD_neu
docker push cwuensch/striptest:all
