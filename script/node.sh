#!/bin/bash

nodenv install 10.12.0
nodenv install 11.1.0
nodenv install 13.7.0
nodenv global 13.7.0

yarn global add eslint@5.8
yarn global add @btmills/eslint-config-btmills@3.2 eslint-plugin-import@2.14
