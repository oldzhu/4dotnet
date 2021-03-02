#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

BASE_DIR=$1/output
TARGET_DIR=$BASE_DIR/target

mkdir -p $TARGET_DIR/root/buildroot/output/
rsync -av -m --include-from=$SCRIPTPATH/includes.txt --exclude='*' $BASE_DIR/ $TARGET_DIR/root/buildroot/output/
