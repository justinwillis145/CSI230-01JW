#/bin/bash

ip addr | grep -oP 'inet \K[\d.]+'
