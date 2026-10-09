FROM alpine:3.19

# Install ping (iputils-ping) and ca-certificates for network checks
RUN apk add --no-cache iputils ca-certificates

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy scripts and adjust permissions
COPY app/ /app/
RUN chmod +x /app/*.sh && chown -R appuser:appgroup /app

USER appuser

ENTRYPOINT ["/app/diagnostic.sh"]
CMD ["help"]