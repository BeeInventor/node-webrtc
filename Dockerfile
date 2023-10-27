# Build webrtc
# https://github.com/BeeInventor/node-webrtc/blob/develop/docs/build-from-source.md
FROM node:18 AS build
ENV SKIP_DOWNLOAD=true
ENV DEBUG=true
WORKDIR /app
RUN git clone https://github.com/BeeInventor/node-webrtc
WORKDIR /app/node-webrtc
RUN apt-get update && apt-get install build-essential cmake python-is-python3 python3-pip ninja-build -y
RUN pip3 install setuptools --break-system-packages
RUN npm install
RUN npm run build
RUN echo buiuld done?
RUN ./node_modules/.bin/ncmake configure && ./node_modules/.bin/ncmake build
RUN npm pack

FROM scratch AS release
WORKDIR /build
COPY --from=build /app/node-webrtc/node-wrtc-0.5.0.tgz /build/node-wrtc-0.5.0.tgz
ENTRYPOINT ["ls", "/build/Release"]
