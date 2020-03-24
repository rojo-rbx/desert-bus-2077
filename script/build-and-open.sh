#!/bin/sh

rojo build --watch -o Place.rbxlx &
sleep 1s
start Place.rbxlx
rojo serve