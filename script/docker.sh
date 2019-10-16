#!/bin/bash

if [[ ! -f '/usr/local/bin/docker' ]]; then
  curl https://download.docker.com/mac/stable/Docker.dmg -o ~/Downloads/Docker.dmg
  (cd ~/Downloads && open Docker.dmg)
  rm -rf ~/Downloads/Docker.dmg
fi
