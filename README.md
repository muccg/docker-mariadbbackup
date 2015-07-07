MariaDB (nee MySQL) backup based on http://sourceforge.net/projects/automysqlbackup/

docker run -it -v /data/mariadbbackup:/data -v /etc/localtime:/etc/localtime:ro -e CONFIG_mysql_dump_password='xxxxx' -e CONFIG_mysql_dump_host='mariadb' --link mariadb:mariadb muccg/mariadbbackup backup
