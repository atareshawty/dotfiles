#!/bin/bash

rbenv init
for version in "2.5.1" "2.6.1"; do
  RUBY_CONFIGURE_OPTS="--with-readline-dir=$(brew --prefix readline)" rbenv install $version
  RBENV_VERSION=$version ~/.rbenv/shims/gem install bundler
done
