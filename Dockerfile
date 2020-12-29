FROM 0x01be/codec2 as codec2

FROM 0x01be/base

COPY --from=codec2 /opt/codec2/ /opt/codec2/

ENV LD_LIBRARY_PATH=/lib:/usr/lib/:/opt/sdrangel/lib \
    C_INCLUDE_PATH=/usr/include:/opt/sdrangel/include \
    PATH=${PATH}:/opt/sdrangel/bin \
    REVISION=master
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
    opus-dev \
    libusb-dev &&\
    apk add --no-cache --virtual sdrangel-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    samurai \   
    opencv-dev
RUN git clone --depth 1  https://github.com/f4exb/serialDV.git /serialdv &&\
    git clone --depth 1  https://github.com/f4exb/dsdcc.git /dsdcc &&\
    git clone --depth 1  https://github.com/f4exb/libsigmf.git /libsigmf &&\
    git clone --depth 1  https://github.com/osmocom/rtl-sdr.git /librtlsdr &&\
    git clone --recursive https://github.com/szechyjs/mbelib.git /mbelib &&\
    git clone --recursive --branch ${REVISION} https://github.com/f4exb/sdrangel.git /sdrangel

WORKDIR /serialdv/build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/srdangel \
    ..
RUN make
RUN make install

WORKDIR /libsigmf/build
RUN cmake \
    -Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/opt/srdangel \
    ..
RUN make
RUN make install

WORKDIR /librtlsdr/build
RUN cmake \
    -Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/opt/srdangel \
    ..
RUN make
RUN make install

WORKDIR /mbelib/build
RUN cmake \
    -Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/opt/srdangel \
    ..
RUN make
RUN make install

WORKDIR /dsdcc/build
RUN cmake \
    -Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/opt/sdrangel \
    -DUSE_MBELIB=ON \
    -DLIBMBE_INCLUDE_DIR=/opt/sdrangel/include \
    -DLIBMBE_LIBRARY=/opt/sdrangel/lib/libmbe.so \
    -DLIBSERIALDV_INCLUDE_DIR=/opt/sdrangel/include/serialdv \
    -DLIBSERIALDV_LIBRARY=/opt/sdrangel/lib/libserialdv.so \
    ..
RUN make
RUN make install

WORKDIR /sdrangel/build
RUN cmake \
    -Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/opt/sdrangel \
    -DSERIALDV_DIR=/opt/sdrangel \
    -DMBE_DIR=/opt/sdrangel \
    -DCODEC2_DIR=/opt/codec2 \
    -DLIBSIGMF_DIR=/opt/sdrangel \
    -DDSDCC_DIR=/opt/sdrangel \
    -DRX_SAMPLE_24BIT=ON \
    -DBUILD_SERVER=OFF \
    ..
RUN make
RUN make install

