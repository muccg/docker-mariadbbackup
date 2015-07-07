#!/bin/bash
#
: ${CONFIG_configfile:="/etc/automysqlbackup/automysqlbackup.conf"}
: ${CONFIG_backup_dir:='/data/backup'}
: ${CONFIG_do_monthly:="01"}
: ${CONFIG_do_weekly:="5"}
: ${CONFIG_rotation_daily:=6}
: ${CONFIG_rotation_weekly:=35}
: ${CONFIG_rotation_monthly:=150}
: ${CONFIG_mysql_dump_usessl:='yes'}
: ${CONFIG_mysql_dump_username:='root'}
: ${CONFIG_mysql_dump_password:=''}
: ${CONFIG_mysql_dump_host:='mysql'}
: ${CONFIG_mysql_dump_socket:=''}
: ${CONFIG_mysql_dump_create_database:='no'}
: ${CONFIG_mysql_dump_use_separate_dirs:='yes'}
: ${CONFIG_mysql_dump_compression:='gzip'}
: ${CONFIG_mysql_dump_commcomp:='no'}
: ${CONFIG_mysql_dump_latest:='no'}
: ${CONFIG_mysql_dump_max_allowed_packet:=''}
: ${CONFIG_db_names:=()}
: ${CONFIG_db_month_names:=()}
: ${CONFIG_db_exclude:=( 'information_schema' 'performance_schema' )}
: ${CONFIG_mailcontent:='stdout'}
: ${CONFIG_mail_maxattsize:=4000}
: ${CONFIG_mail_address:='root'}
: ${CONFIG_encrypt:='no'}
: ${CONFIG_encrypt_password:='password0123'}

export CONFIG_encrypt_password CONFIG_encrypt CONFIG_mail_address CONFIG_mail_maxattsize CONFIG_mailcontent CONFIG_db_exclude CONFIG_db_month_names CONFIG_db_names
export CONFIG_mysql_dump_max_allowed_packet CONFIG_mysql_dump_latest CONFIG_mysql_dump_commcomp CONFIG_mysql_dump_compression CONFIG_mysql_dump_use_separate_dirs CONFIG_mysql_dump_create_database
export CONFIG_mysql_dump_socket CONFIG_mysql_dump_host CONFIG_mysql_dump_password CONFIG_mysql_dump_username CONFIG_mysql_dump_usessl CONFIG_rotation_monthly CONFIG_rotation_weekly
export CONFIG_do_monthly CONFIG_backup_dir CONFIG_configfile

# Dump the config into default config file to let the script run unmodified
env | grep CONFIG_ > /etc/automysqlbackup/automysqlbackup.conf

######################################

echo "HOME is ${HOME}"
echo "WHOAMI is `whoami`"

if [ "$1" = 'backup' ]; then
    echo "[Run] Starting backup"
    date

    (
        flock -n 9 || exit 1
        time /automysqlbackup 2>&1 | tee /data/backup.log
    ) 9>/data/lockfile

    exit $?
fi

echo "[RUN]: Builtin command not provided [backup]"
echo "[RUN]: $@"

exec "$@"
