FROM zouyq/derper:latest
# docker run -it -d -e DERP_DOMAIN=vpn.hostname.com -p 6432:6432 -p 3478:3478/udp --name myderper  -v /usr/local/certs:/cert hotwa/derper:mini 
ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_MODE manual
ENV DERP_CERT_DIR /cert
ENV DERP_ADDR :6432
ENV DERP_STUN true
ENV DERP_HTTP_PORT -1
ENV DERP_VERIFY_CLIENTS false
VOLUME [ "/cert" ]
CMD /derper -c=/derper.conf \
    --hostname=$DERP_DOMAIN \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS