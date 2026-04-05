FROM alpine:3.19

LABEL org.opencontainers.image.source="https://github.com/yourusername/docker-publish-ghcr"

RUN apk add --no-cache curl

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

CMD ["sh", "-c", "echo 'Hello from Docker!' && exec sleep infinity"]
