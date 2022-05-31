FROM asciidoctor/docker-asciidoctor

RUN set -x \
  && apk add --no-cache entr \
  && gem install webrick rghost

