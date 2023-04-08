FROM ubuntu:22.04 as build

ARG ACT_RUNNER_VERSION=linux-amd64
WORKDIR /app

# Build requirements
RUN apt-get update -yq
RUN apt-get install -yq curl ca-certificates

# Download docker compose
RUN mkdir -p /root/.docker/cli-plugins
RUN curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /root/.docker/cli-plugins/docker-compose
RUN chmod +x /root/.docker/cli-plugins/docker-compose

# Download act_runner
RUN curl https://dl.gitea.com/act_runner/main/act_runner-main-${ACT_RUNNER_VERSION} --output act_runner
RUN chmod +x ./act_runner


# Final image
FROM ubuntu:22.04
ENV GITEA_PORT=3000
COPY --from=build /app /
COPY --from=build /root/.docker /root/.docker
COPY --from=docker:latest /usr/local/bin/docker /usr/bin/docker

RUN apt-get update -yq && \
    apt-get install --no-install-recommends -yq git nodejs && \
    apt-get clean && \
    apt-get autoremove -yq && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /repo/gitea_act && \
    git config --global --add safe.directory /repo

COPY runner_config.yaml /runner_config.yaml
COPY start.sh /init/start.sh
RUN chmod +x /init/start.sh

CMD ["/init/start.sh"]