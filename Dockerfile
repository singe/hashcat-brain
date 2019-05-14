FROM alpine:latest as builder
LABEL maintainer="@singe at SensePost <research@sensepost.com>"

RUN apk update && apk --no-cache add \
    build-base \
    linux-headers \
    git \
  && rm -rf /var/cache/apk/*
WORKDIR /
ARG commit=153a8704e05a8c20d325491e53a9c886ee8f8377
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
