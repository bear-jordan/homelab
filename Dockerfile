FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

ARG SSH_USERNAME
ARG SSH_PASSWORD
RUN useradd -m -s /bin/bash ${SSH_USERNAME} && \
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
