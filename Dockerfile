# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20221004-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.14.2-erlang-25.2-debian-bullseye-20221004-slim
#

FROM elixir:1.14.2-alpine as builder

# install build dependencies
RUN apk add --no-cache build-base git python3 curl

# prepare build dir
WORKDIR /opt/dtt_recharger

ARG MIX_ENV
ENV ENV=$MIX_ENV

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets

# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.17 as app

RUN apk add --no-cache libstdc++ openssl libcrypto1.1 ncurses-libs postgresql-client

WORKDIR /opt/dtt_recharger

ARG MIX_ENV
ENV ENV=$MIX_ENV

# Only copy the final release from the build stage
COPY --from=builder /opt/dtt_recharger/_build/${ENV}/rel/dtt_recharger /opt/dtt_recharger

# CMD ["mix", "phoenix.server"]
# CMD "/opt/dtt_recharger/bin/server"
CMD  /opt/dtt_recharger/bin/migrate &\
    /opt/dtt_recharger/bin/server
