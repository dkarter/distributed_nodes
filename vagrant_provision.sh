#!/bin/sh

ERLANG_VERSION=19.2
ELIXIR_VERSION=1.4.2

# Set language and locale
apt-get install -y language-pack-en
locale-gen --purge en_US.UTF-8
echo "LC_ALL='en_US.UTF-8'" >> /etc/environment
dpkg-reconfigure locales

# Install basic packages
# inotify is installed because it's a Phoenix dependency
apt-get -qq update
apt-get install -y \
  wget \
  git \
  unzip \
  build-essential \
  ntp \
  inotify-tools

# Install Erlang
echo "deb http://packages.erlang-solutions.com/ubuntu xenial contrib" >> /etc/apt/sources.list && \
  apt-key adv --fetch-keys http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
  apt-get -qq update && \
  apt-get install -y -f \
  esl-erlang="1:${ERLANG_VERSION}"

# Install Elixir
cd / && mkdir -p elixir && cd elixir && \
  wget -q https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip && \
  unzip Precompiled.zip && \
  rm -f Precompiled.zip && \
  ln -s /elixir/bin/elixirc /usr/local/bin/elixirc && \
  ln -s /elixir/bin/elixir /usr/local/bin/elixir && \
  ln -s /elixir/bin/mix /usr/local/bin/mix && \
  ln -s /elixir/bin/iex /usr/local/bin/iex

# Install local Elixir hex and rebar for the ubuntu user
su - ubuntu -c '/usr/local/bin/mix local.hex --force && /usr/local/bin/mix local.rebar --force'
