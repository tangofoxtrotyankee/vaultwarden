#!/bin/sh

# Railway platform defaults — sourced by start.sh via /etc/vaultwarden.d/
# Mail on Railway Hobby: set MAIL_PROVIDER=mailjet (or resend) and API keys in Railway env.
# SMTP_* is not required when using an HTTP mail provider.

if [ -z "${RAILWAY_ENVIRONMENT:-}" ] && [ -z "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    return 0 2>/dev/null || exit 0
fi

# Railway assigns a dynamic PORT; Rocket must listen on it.
if [ -n "${PORT:-}" ]; then
    export ROCKET_PORT="${PORT}"
fi

# Verification links, invites, and 2FA emails need the public URL.
if [ -z "${DOMAIN:-}" ]; then
    if [ -n "${RAILWAY_STATIC_URL:-}" ]; then
        export DOMAIN="${RAILWAY_STATIC_URL}"
    elif [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
        export DOMAIN="https://${RAILWAY_PUBLIC_DOMAIN}"
    fi
fi

# Persist data on a Railway Volume mounted at /data.
if [ -z "${DATA_FOLDER:-}" ] && [ -d /data ]; then
    export DATA_FOLDER=/data
fi
