FROM 0x01be/sdrangel:build as build

FROM 0x01be/xpra

RUN apk add --no-cache --virtual sdrangel-runtime-dependencies \
    qt5-qtbase \
    qt5-qtwebengine \
    qt5-qtwebsockets \
    qt5-qtmultimedia \
    qt5-qttools \
    qt5-qtwayland \
    boost \
    fftw \
    opus \
    libusb &&\
    apk add --no-cache --virtual sdrangel-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    samurai \   
    opencv

USER ${USER}
ENV PATH=${PATH}:/opt/sdrangel/bin \
    COMMAND=sdrangel

