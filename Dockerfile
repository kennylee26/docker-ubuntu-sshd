# Ubuntu SSH-Server
#
# VERSION 0.0.1
# Base images: https://docs.docker.com/examples/running_ssh_service/
# Authoer: kennylee26
# NAME: kennylee26/sshd
# Command format: Instruction [arguments command] ..

# 第一行必须指定基于的基础镜像
FROM ubuntu:14.04

# 维护者信息
MAINTAINER kennylee26 <kennylee26@gmail.com>

# Install.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y openssh-server && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

# Add root password
RUN echo 'root:111111' | chpasswd

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Define working directory.
WORKDIR /root

# Define default command.
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
