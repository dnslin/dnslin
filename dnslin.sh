#!/usr/bin/env bash

tmpdir="/tmp/dnslin"
[ -d "${tmpdir}" ] || mkdir -p ${tmpdir}

docker_compose_amd64="https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64"
docker_compose_aarch64="https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-aarch64"

jdk_amd64="https://objectstorage.ap-chuncheon-1.oraclecloud.com/n/axvgf8otgjuo/b/debian/o/jdkjdk-8u321-linux-x64.tar.gz"
jdk_aarch64="https://vkceyugu.cdn.bspapp.com/VKCEYUGU-c99d1a5b-9981-46ab-8ebb-c79fc51f2da2/aa9c744d-71a4-496c-b775-35fef3f2896f.gz"

maven_any="https://img.dnslv.com/file/maven.zip"

function release_check() {
  if [[ -f /etc/redhat-release ]]; then
    yum update
    yum install -y wget curl zip unzip tar 
  elif grep -q -E -i "debian|ubuntu" /etc/issue; then
    apt update
    apt install -y wget curl zip unzip tar 
  elif grep -q -E -i "centos|red hat|redhat" /etc/issue; then
    yum update
    yum install -y wget curl zip unzip tar 
  elif grep -q -E -i "debian|ubuntu" /proc/version; then
    apt update
    apt install -y wget curl zip unzip tar 
  elif grep -q -E -i "centos|red hat|redhat" /proc/version; then
    yum update
    yum install -y wget curl zip unzip tar 
  else
    printf " 不支持该发行版 \n"
    exit 1
  fi
  bit=$(uname -m)
}

function arch_check() {
  unamem=$(uname -m)
  case ${unamem} in
  x86_64)
    arch=amd64
    ;;
  aarch64 | aarch64_be | arm64 | armv8b | armv8l)
    arch=aarch64
    ;;
  *)
    exit 1
    ;;
  esac
  printf "系统架构为: %s \n" "${arch}"
}

function install_docker_compose() {
  case ${arch} in
  amd64)
    wget -O ${tmpdir}/docker-compose ${docker_compose_amd64}
    ;;
  aarch64)
    wget -O ${tmpdir}/docker-compose ${docker_compose_aarch64}
    ;;
  *)
    exit 1
    ;;
  esac
  chmod +x ${tmpdir}/docker-compose
  mv ${tmpdir}/docker-compose /usr/bin/docker-compose
}

function install_jdk() {
  case ${arch} in
  amd64)
    wget -O ${tmpdir}/jdk ${jdk_amd64}
    ;;
  aarch64)
    wget -O ${tmpdir}/jdk ${jdk_aarch64}
    ;;
  *)
    exit 1
    ;;
  esac

  cd ${tmpdir}
  tar axvf jdk
  rm -f jdk
  mv jdk* /usr/local/jdk
}

function install_maven() {
  case ${arch} in
  amd64)
    wget -O ${tmpdir}/maven.zip ${maven_any}
    ;;
  aarch64)
    wget -O ${tmpdir}/maven.zip ${maven_any}
    ;;
  *)
    exit 1
    ;;
  esac

  cd ${tmpdir}
  unzip maven.zip
  rm -f maven.zip
  mv apache-maven* /usr/local/maven
}

function profile_conf() {
  printf '\n
export JAVA_HOME=/usr/local/jdk
export JRE_HOME=/usr/local/jdk/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export MAVEN_HOME=/usr/local/maven
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$MAVEN_HOME/bin:$PATH
\n' >> /etc/profile
  source /etc/profile
}

function main() {
  arch_check
  release_check
  install_docker_compose
  install_jdk
  install_maven
  profile_conf
}

main

exit 0