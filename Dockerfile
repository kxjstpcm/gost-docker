FROM alpine

ENV VER=2.11.5
ENV PASSWORD=GameServer
ENV SBVER=1.8.11
ENV IP=2606:4700:110:8406:59ae:6bc1:a364:3455
ENV PK=UP/cEzM/AnCSRmJV7TEHw5K23jQwR62X+2O+XkkFL2M=

RUN apk add --no-cache curl && curl -LO https://github.com/ginuerzh/gost/releases/download/v${VER}/gost-linux-amd64-${VER}.gz && gzip gost-linux-amd64-${VER}.gz -d && chmod +x gost-linux-amd64-${VER} && curl -LO https://github.com/SagerNet/sing-box/releases/download/v${SBVER}/sing-box-${SBVER}-linux-amd64.tar.gz && tar zxvf sing-box-${SBVER}-linux-amd64.tar.gz && chmod +x sing-box-${SBVER}-linux-amd64/sing-box

RUN echo \{\"log\":\{\"disabled\":true\},\"dns\":\{\"servers\":[\{\"tag\":\"dns\",\"address\":\"1.0.0.1\",\"strategy\":\"prefer_ipv6\",\"detour\":\"wg\"\}]\},\"inbounds\":[\{\"listen\":\"127.0.0.1\",\"listen_port\":12345,\"udp_timeout\":300,\"type\":\"socks\"\}],\"outbounds\":[\{\"tag\":\"wg\",\"type\":\"wireguard\",\"server\":\"162.159.195.81\",\"server_port\":7559,\"local_address\":[\"172.16.0.2/32\",\"${IP}/128\"],\"private_key\":\"${PK}\",\"peer_public_key\":\"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=\",\"mtu\":1420\}]\} >/sing-box-${SBVER}-linux-amd64/config.json

CMD nohup sing-box-${SBVER}-linux-amd64/sing-box run -c sing-box-${SBVER}-linux-amd64/config.json & ./gost-linux-amd64-${VER} -L=relay+ws://:10000?path=/$PASSWORD
