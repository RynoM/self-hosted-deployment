# Docker compose CI/CD
While on this self-hosting journey, I've not found any simple solutions that I liked for automatically deploying a docker compose
stack to a single machine. I've played with git hooks and didn't want to go for Github actions (have to expose network). But now with the 
new release of [Gitea Actions](https://blog.gitea.io/2022/12/feature-preview-gitea-actions/), there is another option to self-host a simple 
CI/CD workflow! Nice simple (and Github Actions compatible) workflows, and you can easily store all your 
environment variables in the Gitea repo secrets.

Changes normally come from one of two scenarios:
1) You make changes to your `docker-compose.yml` or something like home assistant's `configuration.yml` in your local IDE.
2) You update something (config) through the UI of a service (say node-red `flows.json`), 
that you want backed up to your repo.

For scenario 1, you can simply make your changes in your comfy local IDE, push them to Gitea and the `deploy.yaml` 
will pull the changes to your server, set environment variables based on your Gitea repo's secrets and update your compose stack.
For scenario 2, once [this PR in Gitea](https://github.com/go-gitea/gitea/pull/22751) is merged, we can use `backup.yaml`
to schedule a workflow that will push your changes from the server to the repo.
Bonus: From Gitea you can set up a mirror to Github, so that you have extra peace of mind.


![Architecture](./img/Architecture.png)

## Setup
The following steps are to be executed on the same server the docker compose stack is meant to run on. It assumes
it's a linux machine with an ssh server running.

1) Use `docker compose up -d gitea` to start Gitea
2) browse to the new Gitea instance and go through initial setup.
3) Since Gitea Actions are still in preview: Enable actions in Gitea's `app.ini` ([see link](https://blog.gitea.io/2022/12/feature-preview-gitea-actions/)) 
and restart Gitea.
```
    # custom/conf/app.ini
    [actions]
    ENABLED = true
```
4) Create a new repo in Gitea. Note: Name the base branch `main` or update the workflows accordingly.
5) Go to the repo's setting in Gitea, check the box: 'Enable Repository Actions' and save.
6) Go to Site Administration -> Runners -> Create new runner and get a runner registration token. 
7) Replace the variables in `docker-compose.yml` or set them as environment variables: 
- `${RUNNER_TOKEN}`
- `${GITEA_IP}` (e.g. 192.168.2.1)
- `${PATH_TO_THIS_REPO}` (e.g. '~/deployment_pipeline')
- `${REPO_NAME}` (e.g. Bob/deployment_pipeline)
8) Add your SSH key to Gitea [example guide](https://www.techaddressed.com/tutorials/add-verify-ssh-keys-gitea/). 
Note: Make sure it doesn't have a passphrase and [permissions are set correctly](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open).
9) Run `docker compose up -d gitea_act` to start the actions runner.
10) Add all your environment variables for your other docker compose services to the secrets in the Gitea repo,
using the `SERVER_ENV_PROD` secret name.

Optional:
11) Set Github (or other) as mirror for Gitea repo.

## Usage
In your development environment, set Gitea as the remote for your repo.
Commit and push your work, add your other services to the `docker-compose.yml` and watch the Gitea Actions do the rest!

## TODO / IDEAS
- Could maybe try and get a runner token from Gitea by itself?
- Test the schedule workflow once its released.
- The runner registration token only works once, so if you have to rebuild, you have to refresh 
the token. Maybe there is a solution for this?
- Automatically restart services in the workflow if files in their folders have changed.
- Reduce image size
- Add image to Dockerhub?