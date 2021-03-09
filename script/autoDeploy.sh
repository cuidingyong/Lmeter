#!/bin/bash

ROOT_PATH=/alidata1/admin/
PT_DIR=pt

usage() {
  echo "Usage: sh $0 [dirname]"
  echo "Eg. sh $0 st"
  echo "If dirname is not specified, the default value is used"
}

dirCreate() {
  echo "开始搭建性能测试环境 ......"
  ROOT_DIR=${ROOT_PATH}${PT_DIR}
  echo "开始创建根目录：${ROOT_DIR} ......"
#  if [ ! -d "$ROOT_DIR" ]; then
#      mkdir $ROOT_DIR
#  fi
  SCRIPT_DIR=$ROOT_DIR"/script"
  echo "开始创建shell脚本目录：${SCRIPT_DIR} ......"
}

if [ $# -eq 1 ] && [ "$1" = "-h" ] || [ $# -gt 1 ]; then
  usage
  exit 1
  elif [ $# -eq 1 ]; then
      PT_DIR=$1
fi
dirCreate
