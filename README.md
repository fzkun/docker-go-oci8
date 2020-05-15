# docker-go-oci8
基于golang:latest封装的oci8驱动镜像，支持go对Oracle数据库查询的运行环境

## 构建镜像脚本
执行release_builder.bat

## 使用demo
main.go
```go
package main

import (
	"fmt"
	"github.com/go-xorm/xorm"
	_ "github.com/mattn/go-oci8"
	"net/url"
)

func main() {
	TestFunc()
}

func TestFunc() {
	pwd := url.QueryEscape("")
	//创建orm引擎
	engine, err := xorm.NewEngine("oci8", "user/"+pwd+"@ip:1521/db")
	if err != nil {
		fmt.Println(err)
		return
	}
	//连接测试
	if err := engine.Ping(); err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("ping ok")
	//日志打印SQL
	engine.ShowSQL(true)

	//设置连接池的空闲数大小
	engine.SetMaxIdleConns(5)
	//设置最大打开连接数
	engine.SetMaxOpenConns(5)

	result, err := engine.QueryInterface(`
select * from HR.COUNTRIES
`)
	fmt.Println(err)
	fmt.Println(result)
}

```

Dockerfile
```
FROM fzkun/go-oci8:latest

#创建工程文件夹
ENV GO111MODULE on
ENV GOPROXY https://goproxy.io,direct
ENV GOSUMDB off
RUN mkdir -p /app

WORKDIR /app
# 拷贝当前目录代码到镜像
COPY main.go /app
RUN go mod init demo
RUN go mod tidy

RUN go run main.go
```

result 
```
[xorm] [info]  2020/05/13 09:50:35.170938 [SQL]
select * from HR.COUNTRIES
<nil>
[map[COUNTRY_ID:AR COUNTRY_NAME:Argentina REGION_ID:2] map[COUNTRY_ID:AU COUNTRY_NAME:Australia REGION_ID:3] map[COUNTRY_ID:BE COUNTRY_NAME:Belgium REGION_ID:1] map[C
OUNTRY_ID:BR COUNTRY_NAME:Brazil REGION_ID:2] map[COUNTRY_ID:CA COUNTRY_NAME:Canada REGION_ID:2] map[COUNTRY_ID:CH COUNTRY_NAME:Switzerland REGION_ID:1] map[COUNTRY_I
D:CN COUNTRY_NAME:China REGION_ID:3] map[COUNTRY_ID:DE COUNTRY_NAME:Germany REGION_ID:1] map[COUNTRY_ID:DK COUNTRY_NAME:Denmark REGION_ID:1] map[COUNTRY_ID:EG COUNTRY
_NAME:Egypt REGION_ID:4] map[COUNTRY_ID:FR COUNTRY_NAME:France REGION_ID:1] map[COUNTRY_ID:IL COUNTRY_NAME:Israel REGION_ID:4] map[COUNTRY_ID:IN COUNTRY_NAME:India RE
GION_ID:3] map[COUNTRY_ID:IT COUNTRY_NAME:Italy REGION_ID:1] map[COUNTRY_ID:JP COUNTRY_NAME:Japan REGION_ID:3] map[COUNTRY_ID:KW COUNTRY_NAME:Kuwait REGION_ID:4] map[
COUNTRY_ID:ML COUNTRY_NAME:Malaysia REGION_ID:3] map[COUNTRY_ID:MX COUNTRY_NAME:Mexico REGION_ID:2] map[COUNTRY_ID:NG COUNTRY_NAME:Nigeria REGION_ID:4] map[COUNTRY_ID
:NL COUNTRY_NAME:Netherlands REGION_ID:1] map[COUNTRY_ID:SG COUNTRY_NAME:Singapore REGION_ID:3] map[COUNTRY_ID:UK COUNTRY_NAME:United Kingdom REGION_ID:1] map[COUNTRY
_ID:US COUNTRY_NAME:United States of America REGION_ID:2] map[COUNTRY_ID:ZM COUNTRY_NAME:Zambia REGION_ID:4] map[COUNTRY_ID:ZW COUNTRY_NAME:Zimbabwe REGION_ID:4]]
```