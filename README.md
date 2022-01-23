# よく使うコマンド
## 再起動
```
sudo shutdown -r now
```

## 指定した間隔でコマンドを実行
```
watch -n 1 docker ps -a
```

## 指定した間隔でプロセスを確認
```
top -d 1
```

## SCPでディレクトリ毎ファイル転送
＊ ローカルのターミナルで実行
```
scp -r chap02 kewtons-agx@192.168.11.8:/home/kewtons-agx/media/dev/computervision_ai
```

## デーモンプロセスを確認する

# 注意
https://forums.developer.nvidia.com/t/docker-containers-wont-run-after-recent-apt-get-upgrade/194369/11

# やること
## 準備
1. まずやる
    ```
    sudo apt update
    sudo apt upgrade
    ```

1. sudo apt upgradeをするとDockerコンテナがうまく動作しなくなるのでグレードダウンを実施
    - https://forums.developer.nvidia.com/t/docker-containers-wont-run-after-recent-apt-get-upgrade/194369/15
    ```
    wget https://launchpad.net/ubuntu/+source/docker.io/20.10.2-0ubuntu1~18.04.2/+build/21335731/+files/docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo dpkg -i docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    rm docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo apt install containerd=1.5.2-0ubuntu1~18.04.3
    ```

1. exfatを使用可能にする
    ```
    sudo add-apt-repository universe
    sudo apt update
    sudo apt install exfat-fuse exfat-utils
    ```

1. SDカードマウント
    ```
    cd /home/kewtons-agx
    mkdir media
    sudo mount /dev/sda1 /home/kewtons-agx/media/
    ```

1. ubuntu起動時にマウント
    1. uuidを確認
        ```
        sudo fdisk -l
        sudo blkid /dev/sda1
        ```
        例）/dev/sda1: LABEL="Samsung UFS" UUID="A833-362D" TYPE="exfat" PARTUUID="00000001-01"
    1. 編集
        ```
        vi /etc/fstab
        ```
        ```
        UUID=A833-362D       /home/kewtons-agx/media auto    defaults        0       0
        ```

    1. gpu確認用ツールのインストール
        ```
        sudo apt install python-pip
        sudo -H pip install jetson-stats
        sudo jtop
        ```

## コンテナ関係
### コマンド

### 実行手順
1. Dockerfileの作成
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorflow
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml
    ```
    FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3

    WORKDIR /home

    COPY init.sh init.sh

    RUN sh init.sh

    RUN mkdir /home/mnt

    WORKDIR /home/mnt
    ```

1. docker-compose.yamlの作成
    ```
    version: "3.7"
    services:
    jetpack:
        build: .
        container_name: mynoo_jet
        runtime: nvidia
        network_mode: host
        stdin_open: true
        volumes:
        - /home/kewtons-agx/media:/home/mnt
    ```

1. docker-composeを使用してdockerをrun
    ```
    docker-compose -f docker-compose.yaml up --build -d
    ```

1. 実行中のコンテナにshでログイン
    ```
    docker exec -it mynoo_jet sh
    # jupyter notebook password
    # nvidia
    jupyter lab --ip=* --allow-root
    ```

# dockerコマンド整理
1. 作動中のコンテナ一覧を表示
    ```
    docker ps
    # 停止中のコンテナも全て一覧表示
    docker ps --all
    ```
1. Stop
    ```
    docker stop mynoo_jet
    ```
1. 停まったコンテナを削除 (Remove)
    ```
    docker rm mynoo_jet
    ```


### aaaaa
1. コンテナ
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml
    ```
    sudo docker pull nvcr.io/nvidia/l4t-ml:r32.6.1-py3
    sudo docker run -it --rm --runtime nvidia --network host nvcr.io/nvidia/l4t-ml:r32.6.1-py3

    # ホストの/home/kewtons-agx/mediaを/homeにマウント
    sudo docker run -v /home/kewtons-agx/media:/home -it --rm --runtime nvidia --network host nvcr.io/nvidia/l4t-ml:r32.6.1-py3

    

    sudo docker pull nvcr.io/nvidia/l4t-ml:r32.4.2-py3
    sudo docker run -it --rm --runtime nvidia --network host nvcr.io/nvidia/l4t-ml:r32.4.2-py3
    ```




1. docker compose
    ```
    sudo apt install python3-pip
    sudo pip3 install --upgrade pip
    sudo apt install build-essential libssl-dev libffi-dev python3-dev
    sudo pip3 install docker-compose

    docker-compose -f docker-compose_1.yaml up -d
    docker exec -it mynoo_jet sh
    ```
    http://192.168.11.8:8888 (password nvidia)


    docker-compose -f docker-compose_1.yaml up --build
    docker exec -it mynoo_jet sh

