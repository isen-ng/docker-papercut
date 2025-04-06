# Papercut MF server

This is a docker container of a trial version of the papercut mf server. This is created for development and
testing purposes and not meant to run in production in any capacity.

**Important**: By using this image, you agree to [papercut's eula](https://www.papercut.com/help/manuals/ng-mf/common/license/).

**Important**: This image is x86 only, because Papercut MP is x86 only. To use this effectively on ARM, enable 
Rosetta emulation on docker desktop

## Registries

* https://hub.docker.com/r/isengrim/papercut

## Tags

* `21.0.4.57587`, `latest`

## Features

* Standalone installation of papercut mf server
* Standalone installation of cups
* Starts an ssh server to accept papercut server commands remotely
    - https://www.papercut.com/help/manuals/ng-mf/common/tools-server-command
* Papercut is setup to automatically pick up new prints created in cups
* Sample `lorem-ipsum.pdf` is included to allow users to easily send a print
    - `docker exec <container> runuser -l <user> "lp -d nul /lorem-ipsum.pdf"`

## Example docker command

```
# 9191 exposes papercut server (http://localhost:9191)
# 631 exposes cups admin (http://localhost:631/admin)

docker run -d \
    -p 9191:9191 \
    -p 631:631 \
    isengrim/papercut:latest
```

## Example docker-compose

The papercut server requires several manual steps before it can be used. These steps has to be manually
click through the UI and is impossible to automate by API. Fortunately, this can be automated by writing a 
selenium script.

After that, we can run `server-command`s to further configure the server. See [server-commands](https://www.papercut.com/help/manuals/ng-mf/common/tools-server-command/).

## Troubleshooting

### PaperCut server keeps crashing

#### Out of memory

One possible cause is that your machine is running out of memory. Allocate more memory or close other apps

#### Ensure your shell is running in x86 mode

Use `uname -a` to check which mode your shell is running in. Force it into x86 mode.


