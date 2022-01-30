# 概要
NVIDIAの組み込みシングルボードコンピュータであるJetson上にコンテナ技術を使用して複数のAI実行環境を構築します。<br>
Jetsonを使用する理由は３つです。

- 安価にCUDAが使用できる（数万円〜）
- Jetpack SDKとNvidia NGCによりすぐに使えるコンテナが用意されている
- 小型（手のひらサイズ）かつ高電力効率により手軽に始めるられる

ここでは、Nvidia NGCに用意されているコンテナイメージを使用して下記の３つの環境を構築します<br>

&#9312; tensorflowがセットアップされた環境<br>
- コンテナイメージ<br>
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorflow

&#9313; pytorchがセットアップされた環境<br>
- コンテナイメージ<br>
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch

&#9314; 機械学習全般がセットアップされた環境<br>
- コンテナイメージ<br>
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml


# Jetsonのセットアップ
## Dockerのセットアップ
1. アプリケーションの最新化
    ```
    sudo apt update
    sudo apt upgrade
    ```

1. jetsonでは、sudo apt upgradeをするとDockerコンテナがうまく動作しなくなるのでcontainerのグレードダウンを実施
    - https://forums.developer.nvidia.com/t/docker-containers-wont-run-after-recent-apt-get-upgrade/194369/15
    ```
    wget https://launchpad.net/ubuntu/+source/docker.io/20.10.2-0ubuntu1~18.04.2/+build/21335731/+files/docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo dpkg -i docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    rm docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo apt install containerd=1.5.2-0ubuntu1~18.04.3
    ```

## リソース使用状況確認ツールのインストール
1. タスクマネージャー相当のリソースの使用状況確認用ツールをインストール
    ```
    sudo apt install python-pip
    sudo -H pip install jetson-stats
    sudo jtop
    ```

## SDカードのマウント
- Jetsonは標準ではディスク容量が少ないのでSDカードをマウントします。
1. exfatを使用可能にする
    ```
    sudo add-apt-repository universe
    sudo apt update
    sudo apt install exfat-fuse exfat-utils
    ```

1. SDカードマウント
    ```
    cd <ディレクトリ>
    mkdir media
    sudo mount /dev/sda1 <ディレクトリ>/media/
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
        UUID=A833-362D       <ディレクトリ>/media auto    defaults        0       0
        ```

# コンテナ環境の構築
## コンテナ環境構築
1. 必要な資産をダウンロードします
    ```
    mkdir <作業用ディレクトリ>
    cd <作業用ディレクトリ>
    rm -rf jetpackcontainers
    git clone https://github.com/Kewton/jetpackcontainers.git
    ```

1. imageを構築・コンテナを構築しバックグラウンドでコンテナを起動
    ```
    # 各コンテナの/home/mntにマウントするローカルマシンのディレクトリを指定します
    # ※3つのコンテナで共通です
    export docker_vol=<マウントするディレクトリ>
    
    # コンテナの起動
    docker-compose -f jetpackcontainers/docker-compose.yaml up --build -d
    ```
    - up：コンテナの構築・起動
    - --build：image構築
    - -d：デタッチモード。バックグラウンドで実行

# dockerコマンド整理
1. docker-composeを使用してdockerをrun
    ```
    docker-compose -f docker-compose.yaml up --build -d
    ```
1. 作動中のコンテナ一覧を表示
    ```
    docker ps
    # 停止中のコンテナも全て一覧表示
    docker ps --all
    ```
1. 実行中のコンテナにbashでログイン
    ```
    docker exec -it <name> bash
    ```
1. コンテナを停止する
    ```
    docker stop <name>
    ```
1. 停止中のコンテナを削除する (Remove)
    ```
    docker rm <name>
    ```

# ubuntuでよく使用するコマンド
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
- ローカルのターミナルで実行
```
scp -r <from_dir> <user>@<ip>:<to_dir>
```

# Jupyter notebook の起動
1. tensorflowがセットアップされた環境にアクセス
    - URL：http://<Jetsonのipアドレス>:8801/login
    - 初期PW：nvidia

1. pytorchがセットアップされた環境にアクセス
    - http://<Jetsonのipアドレス>:8802/login
    - 初期PW：nvidia

1. 機械学習全般がセットアップされた環境にアクセス
    - http://<Jetsonのipアドレス>:8888/login
    - 初期PW：nvidia