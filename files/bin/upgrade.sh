#!/bin/sh
df -h
sudo apt-get update
sudo apt-get upgrade --show-upgraded
sudo apt-get dist-upgrade
sudo apt-get autoremove
sudo apt-get clean all
df -h
