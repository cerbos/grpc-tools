FROM alpine:3.14 as builder
ARG BUF_VERSION=0.56.0
ARG GRPC_VERSION=1.40.0
ARG PROTOC_VERSION=3.17.3
ARG PROTOC_GEN_JAVA_GRPC_VERSION=1.40.0

RUN apk --no-cache add git cmake alpine-sdk wget
WORKDIR /build
RUN git clone --depth 1 --branch v$GRPC_VERSION https://github.com/grpc/grpc --recursive
WORKDIR /build/grpc
RUN cmake .
RUN cmake --build . --target plugins
RUN wget -O buf https://github.com/bufbuild/buf/releases/download/v$BUF_VERSION/buf-Linux-x86_64 && chmod +x buf
RUN wget -O protoc-gen-java-grpc https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/$PROTOC_GEN_JAVA_GRPC_VERSION/protoc-gen-grpc-java-$PROTOC_GEN_JAVA_GRPC_VERSION-linux-x86_64.exe && chmod +x protoc-gen-java-grpc


FROM alpine:3.14
ENV PATH=$PATH:/bin
ENV LD_LIBRARY_PATH=/lib64:/lib
VOLUME ["/source", "/work"]
ENTRYPOINT ["/bin/generate.sh"]

RUN apk --no-cache add ca-certificates libc6-compat gcompat protoc
COPY --from=builder /build/grpc/grpc_csharp_plugin /bin/protoc-gen-csharp-grpc
COPY --from=builder /build/grpc/grpc_node_plugin /bin/protoc-gen-node-grpc
COPY --from=builder /build/grpc/grpc_python_plugin /bin/protoc-gen-python-grpc
COPY --from=builder /build/grpc/protoc-gen-java-grpc /bin/protoc-gen-java-grpc
COPY --from=builder /build/grpc/buf /bin/buf
COPY buf.yaml /buf.yaml
COPY generate.sh /bin/generate.sh
