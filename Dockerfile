# 指定创建的基础镜像
FROM alpine:3.11

# 作者描述信息
MAINTAINER msl4437(https://github.com/msl4437)

RUN apk update && \
    apk add openssh python py-pip && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    ssh-keygen -t dsa -P "" -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
    echo -e '#!/bin/sh\n\nrm -f $0\npasswd=Admin$RANDOM\nif [ ! -z "$PASSWD" ];then\n    passwd=$PASSWD\nfi\necho "当前ROOT密码为$passwd"\necho "root:$passwd"|chpasswd\n\n$@\n/usr/sbin/sshd -D' > /entrypoint.sh
# 开放22端口
EXPOSE 22/TCP

# 执行ssh启动命令
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
