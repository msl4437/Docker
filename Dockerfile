# 指定创建的基础镜像
FROM alpine:latest

# 作者描述信息
MAINTAINER msl4437(https://github.com/msl4437)

RUN apk update && \
    wget --no-check-certificate https://github.com/msl4437/Docker/raw/portainer/portainer-1.22.2.tar.gz && \
    tar -zxf portainer-1.22.2.tar.gz && \
    rm -rf portainer-1.22.2.tar.gz
    
# 开放22端口
EXPOSE 9000/TCP

# 执行ssh启动命令
CMD ["/portainer"]
