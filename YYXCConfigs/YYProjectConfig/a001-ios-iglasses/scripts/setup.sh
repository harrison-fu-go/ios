#!/bin/sh
ruby_version=`cat .ruby-version`
if [[ ! -d "$HOME/.rbenv/versions/$ruby_version" ]]; then
rbenv install $ruby_version;
fi
# Install bunlder
gem install bundler
# Install all gems
bundle 
# update cocoapods repo
bundle exec pod repo update
# Install all pods
bundle exec pod install