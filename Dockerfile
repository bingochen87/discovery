FROM golang:1.22 AS builder
RUN mkdir -p /app/building
WORKDIR /app/building
ADD . /app/building
RUN make build

FROM alpine:3.9.5
# Copy from docker build
COPY --from=builder /app/building/dist/bin/discovery /app/bin/
COPY --from=builder /app/building/dist/conf/discovery.toml /app/conf/
# Copy from local build
#ADD  dist/ /app/
ENV LOG_DIR=/app/log
EXPOSE 7171
WORKDIR /app/
CMD ["/app/bin/discovery", "-conf",  "/app/conf/discovery.toml"]
