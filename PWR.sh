#!/bin/bash

cd $HOME
if [ ! -d "pwr-hca" ]; then
  mkdir -p pwr-hca
fi
cd pwr-hca

if ! sudo ufw status | grep -q "Status: active"; then
  yes | sudo ufw enable
fi

if ! sudo ufw status | grep -q "22/tcp"; then
  sudo ufw allow 22
fi

if ! sudo ufw status | grep -q "80/tcp"; then
  sudo ufw allow 80
fi

if ! sudo ufw status | grep -q "8231/tcp"; then
  sudo ufw allow 8231/tcp
fi

if ! sudo ufw status | grep -q "8085/tcp"; then
  sudo ufw allow 8085/tcp
fi

if ! sudo ufw status | grep -q "7621/udp"; then
  sudo ufw allow 7621/udp
fi

sudo apt update && sudo apt upgrade -y

if ! command -v screen &> /dev/null; then
  sudo apt install screen -y
fi

if ! command -v java &> /dev/null; then
  sudo apt install -y openjdk-19-jre-headless
fi

if [ ! -f validator.jar ]; then
  wget https://github.com/pwrlabs/PWR-Validator/releases/download/13.1.0/validator.jar
fi

if [ ! -f config.json ]; then
  wget https://raw.githubusercontent.com/pwrlabs/PWR-Validator/refs/heads/main/config.json
fi


read -p "请输入您想要设置的密码: " password

echo $password | sudo tee password

SERVER_IP=$(hostname -I | awk '{print $1}')

screen -S pwr -dm
screen -S pwr -p 0 -X stuff $'sudo java -jar validator.jar password '$SERVER_IP' --compression-level 0\n'

echo "验证者节点现在正在后台运行。"
echo "使用以下命令检查：screen -Rd pwr"
echo "欢迎加入TG群组： https://t.me/ksqxszq"
