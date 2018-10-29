FROM alpine:latest as builder
LABEL maintainer="@singe at SensePost <research@sensepost.com>"
LABEL hashcat-version="5.0.0"

RUN apk update && apk add \
  build-base \
  linux-headers \
  git \
&& rm -rf /var/cache/apk/*
WORKDIR /
RUN git clone --depth=1 https://github.com/hashcat/hashcat \
&& cd hashcat \
&& git submodule update --init \
&& make -j2 

From alpine:latest
LABEL maintainer="@singe at SensePost <research@sensepost.com>"

COPY --from=builder /hashcat/hashcat /hashcat/
ENV PATH $PATH:/hashcat
EXPOSE 6863
CMD /hashcat/hashcat --brain-server
