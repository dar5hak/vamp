FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=vala-vamp/build-release /opt/vamp-portable /

RUN apt-get update \
  && apt-get install -y libgio-cil

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

CMD ["/usr/bin/vamp"]
