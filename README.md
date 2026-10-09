Dockerized Diagnostic CLI

A lightweight Alpine-based container image providing a unified command-line diagnostic tool.

## Image Features
- **Base Image**: `alpine:3.19`
- **User**: Non-root `appuser` (UID 1000/1001) for runtime security
- **Package Additions**: `iputils` (for `ping`), `ca-certificates`

## Commands Supported

```bash
# Display help menu
docker run --rm diagnostic-cli help

# Collect system metrics
docker run --rm diagnostic-cli system

# Evaluate disk usage threshold
docker run --rm diagnostic-cli disk 80

# Check host connectivity
docker run --rm diagnostic-cli network google.com
