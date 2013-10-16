#! /bin/bash
###!/usr/bin/env bash

apt-get update && apt-get -y upgrade
apt-get -y install make ruby1.9.1 ruby1.9.1-dev git-core
gem install chef  --no-ri --no-rdoc
