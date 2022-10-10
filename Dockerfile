FROM library/ubuntu:22.04

ENV USER root
ENV HOME /root

WORKDIR $HOME

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN  apt update

RUN  apt upgrade -y

RUN apt install -y curl gpg wget sudo

# Install playit.gg for port forwarding
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg
RUN curl -SsL -o /etc/apt/sources.list.d/playit-cloud.list https://playit-cloud.github.io/ppa/playit-cloud.list

RUN apt update
RUN apt install -y playit

# Install stuff for steamcmd to install our server
RUN curl -SsL http://repo.steampowered.com/steam/archive/stable/steam.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/steam.gpg
steam.gpg
RUN sh -c 'echo "deb http://repo.steampowered.com/steam/ stable steam" >> /etc/apt/sources.list.d/steam.list' 
RUN dpkg --add-architecture i386
RUN apt update

# Config options for steam
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

ARG DEBIAN_FRONTEND=noninteractive

RUN apt install -y steamcmd

# Runs steamcmd and installs the Unturned Dedicated Server
RUN steamcmd +login anonymous +app_update 1110390 +quit
