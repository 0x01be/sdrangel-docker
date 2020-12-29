FROM 0x01be/base

ENV REVISION=master
RUN apk add --no-cache --virtual sdrangel-build-dependencies \
    git \
    build-base \
    cmake \
    qt5-qtbase-dev \
    qt5-qtwebengine-dev \
    qt5-qtwebsockets-dev \
    qt5-qtmultimedia-dev \
    qt5-qttools-dev \
    qt5-qtwayland-dev \
    boost-dev \
    fftw-dev \
    opus-dev &&\
    apk add --no-cache --virtual sdrangel-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    samurai \   
    opencv-dev &&\
    git clone --depth 1 --branch ${REVISION} https://github.com/f4exb/serialDV.git /serialdv &&\
    git clone --recursive --branch ${REVISION} https://github.com/f4exb/sdrangel.git /sdrangel

WORKDIR /serialdv/build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/srdangel \
    ..
RUN make
RUN make install

WORKDIR /sdrangel/build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/sdrangel \
    -DCMAKE_MODULE_PATH=/opt/sdrangel \
    ..
RUN make
RUN make install

