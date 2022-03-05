# Derper

## setup

Different offical docker image close http port ,change default https port

offer china user `china.dockerfile`

offer other user `overseas.dockerfile`

required: set env `DERP_DOMAIN` to your domain

need `your-hostname.com.crt`

| env                 | required | description                                                  | default value     |
| ------------------- | -------- | ------------------------------------------------------------ | ----------------- |
| DERP_DOMAIN         | true     | derper server hostname                                       | your-hostname.com |
| DERP_CERT_DIR       | false    | directory to store LetsEncrypt certs(if addr's port is :443) | /app/certs        |
| DERP_CERT_MODE      | false    | mode for getting a cert. possible options: manual, letsencrypt | manual            |
| DERP_ADDR           | false    | listening server address                                     | :6432             |
| DERP_STUN           | false    | also run a STUN server                                       | true              |
| DERP_HTTP_PORT      | false    | The port on which to serve HTTP. Set to -1 to disable        | -1                |
| DERP_VERIFY_CLIENTS | false    | verify clients to this DERP server through a local tailscaled instance | false             |