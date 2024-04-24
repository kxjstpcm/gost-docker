FROM alpine

ENV VER=2.11.5
ENV PASSWORD=GameServer

RUN apk add --no-cache curl && curl -LO https://github.com/ginuerzh/gost/releases/download/v$VER/gost-linux-amd64-$VER.gz && gzip gost-linux-amd64-$VER.gz -d && chmod +x gost-linux-amd64-$VER

CMD /gost-linux-amd64-$VER -L relay+ws://:10000?path=/$PASSWORD
