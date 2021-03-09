#!/bin/bash
#nohup文件路径
NOHUP_FILE=logs
#所有操作回到父目录执行
cd ..
#给定参数默认值
DATE=$(date +%Y%m%d%H%M%S)
THREADS=1
RAMP_UP=1
CYCLES=-1
DURATION=600

#查看帮助
help() {
  cat <<HELP
Usage: sh executeScript.sh [PARAM]...
性能测试:
  --参数1  jmx脚本名.       必送
  --参数2  线程数.          非必送，默认值1
  --参数3  线程启动时间.    非必送，默认值1
  --参数4  循环次数.        非必送，默认值-1
  --参数5  执行时长.        非必送，默认值600
稳定性测试:
  --参数1  [-s].           必送
  --参数2  jmx脚本名.       必送
HELP
  exit 0
}

#执行稳定性测试，需传入jmx文件名
excST() {
  echo ----------------------------------------------------------
  echo "当前运行脚本-->$1.jmx"
  echo "生成报告名-->$1-${DATE}"
  nohup jmeter -n -t jmx/"$1".jmx -l report/jtl/"$1-${DATE}.jtl" -e -o report/html/"$1-${DATE}.html" >${NOHUP_FILE}/nohup.out 2>&1 &
  exit 0
  echo ----------------------------------------------------------
}

#执行性能测试
excPT() {
  echo ----------------------------------------------------------
  echo "当前运行脚本-->${NAME}.jmx 线程数-->${THREADS} 线程启动时间-->${RAMP_UP}秒 循环次数-->${CYCLES} 执行时长-->${DURATION}秒"
  echo "生成报告名-->${NAME}-${DATE}"
  nohup jmeter -n -t jmx/"${NAME}".jmx -Jnum_threads=${THREADS} -Jramp_up=${RAMP_UP} -Jduration=${DURATION} -Jcycles=${CYCLES} -l report/jtl/"${NAME}-${DATE}".jtl -e -o report/html/"${NAME}-${DATE}".html >${NOHUP_FILE}/nohup.out 2>&1 &
  echo ----------------------------------------------------------
  exit 0
}

#判断文件是否存在
fileExists() {
  myFile=./jmx/${1}.jmx
  if [ ! -f "${myFile}" ]; then
    echo "File ${1}.jmx does not exist"
    echo "Try 'sh executeScript.sh --help' for more information"
    exit 0
  fi
}

if [ -z "$1" ]; then
  echo "This script must send parameters"
  echo "Try 'sh executeScript.sh --help' for more information"
  exit 0
else
  while [ -n "$1" ]; do
    case $1 in
    -h) help ;;
    --help) help ;;
    -s)
      if [ -z "$2" ]; then
        echo "Please enter the name of jmx"
        echo "Try 'sh executeScript.sh --help' for more information"
        exit 0
      else
        excST "$2"
      fi
      ;;
    *)
      fileExists "$1"
      NAME=$1
      if [ -n "$2" ]; then
        THREADS=$2
        if [ -n "$3" ]; then
          RAMP_UP=$3
          if [ -n "$4" ]; then
            CYCLES=$4
            if [ -n "$5" ]; then
              DURATION=$5
            fi
          fi
        fi
      fi
      excPT
      ;;
    esac
  done
fi
