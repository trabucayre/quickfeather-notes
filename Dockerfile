FROM debian:buster
MAINTAINER Gwenhael Goavec-Merou <gwenhael.goavec@trabucayre.com>

ARG uid=500

RUN apt-get update \
	&& apt-get dist-upgrade -y \
	&& apt-get -y install zlib1g-dev virtualenv make gcc git curl \
		ncurses-bin ncurses-base wget g++ cpio unzip bc clang \
		libncurses-dev rsync fasm \
		tcl-dev libreadline-dev pkg-config bison flex libffi-dev \
		cmake libxcursor-dev libxdamage-dev \
		libxcomposite-dev libxinerama-dev libxext-dev \
		libxrandr-dev libxi-dev libiconv-hook-dev \
		gcc-arm-none-eabi python3-simplejson python3-lxml
	
# xsltproc libxml2-utils python-pytest flake8 yapf
# nodejs iverilog npm

RUN groupadd -r -g $uid user && \
	useradd --no-log-init -s /bin/bash -r -g $uid -u $uid user && \
	mkdir /home/user && chown -R user:user /home/user
