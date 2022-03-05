FROM golang:latest AS builder
WORKDIR /app

# https://tailscale.com/kb/1118/custom-derp-servers/
#! add proxy
RUN go env -w GOPROXY=https://goproxy.cn && \
    go install tailscale.com/cmd/derper@main

FROM debian:buster-slim
WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'deb http://mirrors.aliyun.com/debian/ buster main non-free contrib\n\
    deb http://mirrors.aliyun.com/debian-security buster/updates main\n\
    deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\n\
    deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian-security buster/updates main\n\
    deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\n\
    ' > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y ca-certificates && \
    mkdir /app/certs

# nohup ./derper -hostname your-hostname.com -c=derper.conf -a :81 -http-port -1 -certdir /usr/local/cert -certmode manual -stun &
ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_MODE letsencrypt
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :6432
ENV DERP_STUN true
ENV DERP_HTTP_PORT -1
ENV DERP_VERIFY_CLIENTS true

COPY --from=builder /go/bin/derper .

VOLUME [ "/app/certs" ]

CMD /app/derper -c=$HOME/derper.conf \
    --hostname=$DERP_DOMAIN \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS