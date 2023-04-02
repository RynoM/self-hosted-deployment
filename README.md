## Setup
The following steps are to be executed on the same server the docker compose stack is meant to run on. 

1) Use `docker compose up -d gitea` to start Gitea
2) browse to the new gitea instance and go through initial setup.
3) Since Gitea Actions are still in preview: Enable actions in gitea's `app.ini` ([see link](https://blog.gitea.io/2022/12/feature-preview-gitea-actions/)) 
and restart gitea.
```
    # custom/conf/app.ini
    [actions]
    ENABLED = true
```
4) Create a new repo in Gitea and follow the instructions there on how to push it.
5) Go to the repo's setting in Gitea, check the box: 'Enable Repository Actions' and save.
6) Go to Site Administration -> Runners -> Create new runner and get a runner registration token. 
7) Replace `${RUNNER_TOKEN}`, `${GITEA_IP}` (e.g. http://192.168.2.1:3000) and `${PATH_TO_THIS_REPO}` in `docker-compose.yml`
or set them as environment variables.
8) .... ssh key setup
9) Run `docker compose up -d gitea_act` to start the actions runner.


Optional:
9) Set Github (or other) as mirror for Gitea repo.


## Usage


## TODO