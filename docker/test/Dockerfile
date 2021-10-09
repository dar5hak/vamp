FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=vala-vamp/build-dev /opt/vamp/build/tests/vamp-tests /usr/bin/vamp-tests

RUN apt-get update \
  && apt-get install -y libvala-dev libgio2.0-cil-dev

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

CMD ["/usr/bin/vamp-tests"]
