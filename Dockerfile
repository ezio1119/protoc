FROM golang:alpine AS go-builder

RUN apk add --no-cache git make

# install protoc-gen-go
RUN go get github.com/golang/protobuf/protoc-gen-go

# install protoc-gen-validate
RUN go get -d github.com/envoyproxy/protoc-gen-validate && \
    cd ${GOPATH}/src/github.com/envoyproxy/protoc-gen-validate && \
    make build

# install protoc-gen-doc
RUN go get github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

FROM alpine
WORKDIR /proto

RUN apk add --no-cache protobuf-dev
COPY --from=go-builder /go/bin /usr/local/bin
COPY --from=go-builder /go/src/github.com/envoyproxy/protoc-gen-validate/validate/validate.proto /go/src/github.com/envoyproxy/protoc-gen-validate/validate/validate.proto

ENTRYPOINT ["protoc"]