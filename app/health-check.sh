#!/usr/bin/env sh
# Minimal healthcheck verifying script readiness
/app/diagnostic.sh system >/dev/null 2>&1
exit $?