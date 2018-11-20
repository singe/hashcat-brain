FROM alpine:latest as builder
LABEL maintainer="@singe at SensePost <research@sensepost.com>"
LABEL hashcat-version="5.0.0"

RUN apk update && apk add \
  build-base \
  linux-headers \
  git \
&& rm -rf /var/cache/apk/*
WORKDIR /
ARG commit=490050ecb310f484d928e9f9f52fc8b8afef1c89
RUN wget -O hashcat.zip https://github.com/hashcat/hashcat/archive/$commit.zip \
&& unzip hashcat.zip \
&& mv hashcat-$commit hashcat \
&& cd hashcat \
&& make -j2
#RUN git clone --depth=1 https://github.com/hashcat/hashcat \
#&& cd hashcat \
#&& git submodule update --init \
#&& make -j2 

From alpine:latest
LABEL maintainer="@singe at SensePost <research@sensepost.com>"

COPY --from=builder /hashcat/hashcat /hashcat/
ENV PATH $PATH:/hashcat
EXPOSE 6863
ENTRYPOINT [ "/hashcat/hashcat", "--brain-server" ]
