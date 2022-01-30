# https://catalog.ngc.nvidia.com/containers
FROM nvcr.io/nvidia/l4t-pytorch:r32.6.1-pth1.9-py3

WORKDIR /home

COPY pth/init.sh init.sh
COPY pth/requirements.txt requirements.txt

# jupyter notebookを外部から接続する際のパスワードを指定（nvidia）
COPY pth/jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

RUN sh init.sh

RUN mkdir /home/mnt

WORKDIR /home/mnt