# 概要
Jetson AGX Xavierは手のひらサイズの小型マシンですが、ワークステーション並の計算能力を誇り、CPUメモリ16GB、GPUメモ16GBを誇ります。<br>
ここでは、コンテナ技術を使用してJetson AGX Xavier上に複数のAI実行環境を構築します。<br>
　「①tensorflowがセットアップされた環境」と「②pytorchがセットアップされた環境」と「③機械学習全般がセットアップされた環境」の３つの環境を構築します。
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorflow
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch
    - https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml

# コンテナ環境の構築
## Jetson AGX Xavierのセットアップ
1. アプリケーションの最新化
    ```
    sudo apt update
    sudo apt upgrade
    ```

1. jetsonでは、sudo apt upgradeをするとDockerコンテナがうまく動作しなくなるのでグレードダウンを実施
    - https://forums.developer.nvidia.com/t/docker-containers-wont-run-after-recent-apt-get-upgrade/194369/15
    ```
    wget https://launchpad.net/ubuntu/+source/docker.io/20.10.2-0ubuntu1~18.04.2/+build/21335731/+files/docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo dpkg -i docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    rm docker.io_20.10.2-0ubuntu1~18.04.2_arm64.deb
    sudo apt install containerd=1.5.2-0ubuntu1~18.04.3
    ```
1. gpu確認用ツールのインストール
    ```
    sudo apt install python-pip
    sudo -H pip install jetson-stats
    sudo jtop
    ```
## Jetson AGX Xavierのセットアップ
- Jetson AGX Xavierは標準ではディスクが32GBしかないのでSDカードをマウントします。
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
## コンテナ環境構築
1. docker-composeをクローンして実行
    ```
    rm -rf jetpackcontainers
    git clone https://github.com/Kewton/jetpackcontainers.git
    docker-compose -f jetpackcontainers/docker-compose.yaml up --build -d
    ```

# よく使用するコマンド
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
scp -r chap02 <user>@<ip>:<dir>
```

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
1. Stop
    ```
    docker stop <name>
    ```
1. 停まったコンテナを削除 (Remove)
    ```
    docker rm <name>
    ```
1. 実行中のコンテナにshでログイン
    ```
    docker exec -it <name> sh
    ```