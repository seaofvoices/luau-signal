#!/bin/sh

set -e

DARKLUA_CONFIG=$1
BUILD_OUTPUT=$2
CODE_OUTPUT=roblox/$DARKLUA_CONFIG

if [ ! -d node_modules ]; then
    yarn install
    yarn prepare
fi

rojo sourcemap library.project.json --output sourcemap.json

rm -rf $CODE_OUTPUT/src
rm -rf $CODE_OUTPUT/node_modules

darklua process --config $DARKLUA_CONFIG src $CODE_OUTPUT/src
darklua process --config $DARKLUA_CONFIG node_modules $CODE_OUTPUT/node_modules

cp -r library.project.json $CODE_OUTPUT/

mkdir -p $BUILD_OUTPUT

rojo build $CODE_OUTPUT/library.project.json -o $BUILD_OUTPUT/signal.rbxm
