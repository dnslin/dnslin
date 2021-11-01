#!/bin/bash
mkdir -p /usr/soft/shadowsocks
echo "shadowsocks 下载目录在 /usr/soft/shadowsocks/shadowsocks"
chmod 777 /usr/soft/shadowsocks
cd /usr/soft/shadowsocks
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.11.2/shadowsocks-v1.11.2.aarch64-unknown-linux-musl.tar.xz
tar xf shadowsocks-v1.11.2.aarch64-unknown-linux-musl.tar.xz
rm shadowsocks-v1.11.2.aarch64-unknown-linux-musl.tar.xz
./ssserver -m chacha20-ietf-poly1305 -s 0.0.0.0:8388 -k 8ZDndBVFtoao5A7k9EVMPFRHBmUrFVa -U -d
echo "加密:chacha20-ietf-poly1305"
echo "端口:8388"
echo "密码:8ZDndBVFtoao5A7k9EVMPFRHBmUrFVa"
echo "开启UDP"