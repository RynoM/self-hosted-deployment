FROM ubuntu:22.04

ARG ACT_RUNNER_VERSION=linux-amd64
ENV DEBIAN_FRONTEND=noninteractive
ENV GITEA_PORT=3000
ENV DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

RUN apt-get update -yq
RUN apt-get install
RUN apt-get install -yq curl nodejs git ssh # NodeJS required for act_runner

# Add Docker (compose)
COPY --from=docker:latest /usr/local/bin/docker /usr/bin/docker
RUN mkdir -p ${DOCKER_CONFIG}/cli-plugins
RUN curl -SL https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-linux-x86_64 -o ${DOCKER_CONFIG}/cli-plugins/docker-compose
RUN chmod +x ${DOCKER_CONFIG}/cli-plugins/docker-compose

# Get Gitea actions runner
RUN curl https://dl.gitea.com/act_runner/main/act_runner-main-${ACT_RUNNER_VERSION} --output act_runner
RUN chmod +x ./act_runner

ADD start.sh /
RUN chmod +x /start.sh

RUN mkdir -p /repo
RUN git config --global --add safe.directory /repo

CMD ["/start.sh"]