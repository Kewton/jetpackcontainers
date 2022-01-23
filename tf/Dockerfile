FROM nvcr.io/nvidia/l4t-tensorflow:r32.6.1-tf2.5-py3

WORKDIR /home

COPY tf/init.sh init.sh
COPY tf/requirements.txt requirements.txt
COPY tf/jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

RUN sh init.sh

RUN mkdir /home/mnt

WORKDIR /home/mnt