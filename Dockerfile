FROM centos:latest
MAINTAINER The CentOS Project <cloud-ops@centos.org>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd mod_ssl php && \
    yum -y --setopt=tsflags=nodocs install vim bash curl httpd httpd-tools && \
#    yum -y --setopt=tsflags=nodocs install python2 python2-urllib3 python2-openssl python2-requests python2-tools && \
    systemctl enable httpd && \
    yum -y clean all

EXPOSE 80 443

# Simple startup script to avoid some issues observed with container restart
COPY ./code.tgz /code.tgz
COPY ./conf.tgz /conf.tgz
RUN mkdir -p /var/www/html && \
    cd / && \
    tar -xzvf conf.tgz && \
    cd /var/www/html && \
    tar -xzvf code.tgz

ENTRYPOINT ["/usr/sbin/init"]
