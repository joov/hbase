#!/bin/bash

TARBALL=$1
URL=$2
PREFIX=$3

wget $URL
tar xvf $TARBALL  --directory=/usr/local
mv /usr/local/$PREFIX-* /usr/local/$PREFIX
rm $TARBALL
