# Build webrtc
# https://github.com/BeeInventor/node-webrtc/blob/develop/docs/build-from-source.md
FROM node:18 AS build
ENV SKIP_DOWNLOAD=true
ENV PARALLELISM=2
WORKDIR /app
RUN git clone https://github.com/BeeInventor/node-webrtc
WORKDIR /app/node-webrtc
#RUN apt-get update && apt-get install build-essential libc6-dev cmake python python-pip ninja-build -y
RUN apt-get update && apt-get install build-essential libc6-dev cmake python-is-python3 ninja-build python3-pkg-resources libglib2.0-dev clang libc++-dev libc++abi-dev -y
#RUN pip install setuptools
#RUN pip3 install setuptools --break-system-packages
RUN npm install
RUN npm run build
RUN ./node_modules/.bin/ncmake configure && ./node_modules/.bin/ncmake build
RUN npm pack

FROM scratch AS release
WORKDIR /build
COPY --from=build /app/node-webrtc/node-wrtc-0.5.0.tgz /build/node-wrtc-0.5.0.tgz
ENTRYPOINT ["ls", "/build/Release"]
