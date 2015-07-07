#
FROM muccg/mariadb-galera:5.5
MAINTAINER https://github.com/muccg/

RUN mkdir -p /data \
  && chown mysql:mysql /data

RUN mkdir -p /etc/automysqlbackup \
  && chown mysql:mysql /etc/automysqlbackup

COPY automysqlbackup /
COPY docker-entrypoint.sh /

USER mysql
ENV HOME /data
WORKDIR /data
VOLUME /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["backup"]
