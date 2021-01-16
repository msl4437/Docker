# 指定创建的基础镜像
FROM alpine:latest

# 作者描述信息
MAINTAINER msl4437(https://github.com/msl4437)

RUN apk update && \
    apk add openssh && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    ssh-keygen -t dsa -P "" -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
    echo -e '#!/bin/sh\nrm -f $0\npasswd=Admin$RANDOM\nif [ ! -z "$PASSWD" ];then\n    passwd=$PASSWD\nfi\necho "当前ROOT密码为$passwd"\necho "root:$passwd"|chpasswd\n\nmysqladmin -u root password "$passwd"\nmysql -u root -p$passwd -e"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$passwd' WITH GRANT OPTION;"\nmysql -u root -p$passwd -e"FLUSH PRIVILEGES;"\n\n$@\n/usr/sbin/sshd -D' > entrypoint.sh
    
    apk add mysql mysql-client && \
    sed -i "s/skip-networking/user=mysql/g" /etc/my.cnf.d/mariadb-server.cnf && \
    mysql_install_db --datadir=/home/mysql && \
    mysqld_safe --nowatch --datadir=/var/lib/mysql

# 开放22端口
EXPOSE 22/TCP 3306/TCP

# 执行ssh启动命令
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
