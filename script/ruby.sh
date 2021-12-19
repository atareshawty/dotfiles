#!/bin/bash

rbenv init
for version in "2.7.5" "3.0.3"; do
  RUBY_CONFIGURE_OPTS="--with-readline-dir=$(brew --prefix readline)" rbenv install $version
  RBENV_VERSION=$version ~/.rbenv/shims/gem install bundler
done
