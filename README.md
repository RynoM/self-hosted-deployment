## Setup
The following steps are to be executed on the same server the docker compose stack is meant to run on. 

1) Use `docker compose up -d gitea` to start Gitea
2) browse to the new Gitea instance and go through initial setup.
3) Since Gitea Actions are still in preview: Enable actions in Gitea's `app.ini` ([see link](https://blog.gitea.io/2022/12/feature-preview-gitea-actions/)) 
and restart Gitea.
```
    # custom/conf/app.ini
    [actions]
    ENABLED = true
```
4) Create a new repo in Gitea.
5) Go to the repo's setting in Gitea, check the box: 'Enable Repository Actions' and save.
6) Go to Site Administration -> Runners -> Create new runner and get a runner registration token. 
7) Replace the variables in `docker-compose.yml` or set them as environment variables: 
- `${RUNNER_TOKEN}` 
- `${GITEA_IP}` (e.g. 192.168.2.1:3000) 
- `${PATH_TO_THIS_REPO}` (e.g. '~/deployment_pipeline')
- `${REPO_NAME}` (e.g. Bob/deployment_pipeline)
8) Add your SSH key to Gitea [example guide](https://www.techaddressed.com/tutorials/add-verify-ssh-keys-gitea/). 
9) Run `docker compose up -d gitea_act` to start the actions runner.


Optional:
9) Set Github (or other) as mirror for Gitea repo.


## Usage


## TODO