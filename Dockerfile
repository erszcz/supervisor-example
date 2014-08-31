FROM ubuntu:14.04
MAINTAINER Radek Szymczyszyn <lavrin@gmail.com>

RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ssh/docker.id_rsa.pub /root/.ssh/authorized_keys

# Disabling PAM seems to be necessary in order to allow root login w/key.
# Otherwise the SSH session is terminated immediately after (successful!) auth.
RUN sed -i '/UsePAM yes/c\UsePAM no' /etc/ssh/sshd_config
RUN sed -i '/PermitRootLogin no/c\PermitRootLogin yes' /etc/ssh/sshd_config

EXPOSE 22
CMD exec supervisord -n
