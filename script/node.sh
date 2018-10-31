#!/bin/bash

nodenv install 10.12.0
nodenv global 10.12.0

yarn global add eslint@5.8
yarn global add @btmills/eslint-config-btmills@3.2 eslint-plugin-import@2.14
