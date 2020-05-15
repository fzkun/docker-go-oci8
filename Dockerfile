FROM golang:latest

#安装oci
RUN apt-get update
RUN apt-get install -y pkg-config && \
    apt-get install -y libaio1 && \
    apt-get install unzip

ENV CLIENT_FILENAME instantclient_19_6.zip
COPY ${CLIENT_FILENAME} .
COPY oci8.pc /usr/lib/pkgconfig/oci8.pc

ENV PKG_CONFIG_PATH /usr/lib/pkgconfig
RUN ls -lha /usr/lib/pkgconfig
ENV LD_LIBRARY_PATH /opt/instantclient

RUN unzip ${CLIENT_FILENAME} -d /opt
RUN mv /opt/instantclient_19_6 /opt/instantclient
RUN ls -lha /opt/instantclient &&  \
    rm /opt/instantclient/libclntsh.so && \
    ln -s /opt/instantclient/libclntsh.so.19.1 /opt/instantclient/libclntsh.so && \
    ln -s /opt/instantclient/libclntshcore.so.19.1 /opt/instantclient/libclntshcore.so && \
    rm /opt/instantclient/libocci.so && \
    ln -s /opt/instantclient/libocci.so.19.1 /opt/instantclient/libocci.so

RUN go get -u github.com/mattn/go-oci8


#创建工程文件夹
#ENV GO111MODULE on
#ENV GOPROXY https://goproxy.io,direct
#ENV GOSUMDB off
#RUN mkdir -p /app
#
#WORKDIR /app
## 拷贝当前目录代码到镜像
#COPY main.go /app
#RUN go mod init demo
#RUN go mod tidy
#
#
#RUN go run main.go

