FROM nvcr.io/nvidia/l4t-pytorch:r32.6.1-pth1.9-py3

WORKDIR /home

COPY py/init.sh init.sh
COPY py/requirements.txt requirements.txt
COPY py/jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

RUN sh init.sh

RUN mkdir /home/mnt

WORKDIR /home/mnt