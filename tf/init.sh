# start
echo "Start" > hoge.txt
echo date >> hoge.txt

# pythonの必要ライブラリのインストール
python3 -m pip install --upgrade pip
echo date >> hoge.txt
python3 -m pip install -r requirements.txt
echo date >> hoge.txt

# end
echo "End" >> hoge.txt