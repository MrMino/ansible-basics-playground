FROM ubuntu:20.04
MAINTAINER Blazej Michalik

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3 python3-pip openssh-server rsync
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

RUN mkdir /root/.ssh && mkdir /run/sshd
COPY id_rsa.pub /root/.ssh/authorized_keys
COPY id_rsa.pub id_rsa /root/.ssh/
ENTRYPOINT /usr/sbin/sshd -Dep 12345

EXPOSE 12345
EXPOSE 80
