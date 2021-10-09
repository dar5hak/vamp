FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /opt/vamp-portable

RUN apt-get update \
  && apt-get install -y libvala-dev valac meson

ARG build_args
COPY . /opt/vamp

WORKDIR /opt/vamp

RUN meson build ${build_args} --prefix=/usr 
RUN meson compile -C build 
RUN DESTDIR=/opt/vamp-portable meson install -C build
