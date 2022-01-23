FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3

WORKDIR /home

COPY ml/init.sh init.sh

RUN sh init.sh

RUN mkdir /home/mnt

WORKDIR /home/mnt