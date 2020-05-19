FROM golang:alpine AS go-builder

RUN apk add --no-cache git make

RUN go get github.com/golang/protobuf/protoc-gen-go

RUN go get -d github.com/envoyproxy/protoc-gen-validate && \
    cd ${GOPATH}/src/github.com/envoyproxy/protoc-gen-validate && \
    make build

RUN go get github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

FROM alpine
WORKDIR /proto

RUN apk add --no-cache protobuf-dev
COPY --from=go-builder /go/bin /usr/local/bin

ENTRYPOINT ["protoc"]