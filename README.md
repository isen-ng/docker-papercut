# Papercut MF server

This is a docker container of a trial version of the papercut mf server. This is created for development and
testing purposes and not meant to run in production in any capacity.

**Important**: By using this image, you agree to [papercut's eula](https://www.papercut.com/help/manuals/ng-mf/common/license/).

**Important**: This image is x86 only, because Papercut MP is x86 only. To use this effectively on ARM, enable 
Rosetta emulation on docker desktop

## Registries

* https://registry.hub.docker.com/r/isengrim/papercut

## Tags

* `21.0.4.57587`, `latest`

## Features

* Standalone installation of papercut mf server
* Stanaalone installation of cups
* Papercut is setup to automatically pick up new prints created in cups
* Sample `lorem-ipsum.pdf` is included to allow users to easily send a print
    - `docker exec <container> runuser -l <user> "lp -d nul /lorem-ipsum.pdf"`

## Example docker command

```
docker run -d \
    -p 9191:9191 \
    -p 631:631
    isengrim/papercut:latest
```

## Example docker-compose

The papercut server requires several manual steps before it can be used. These steps has to be manually
click through the UI and is impossible to automate by API. Fortunately, this can be automated by writing a 
selenium script.

After that, we can run `server-command`s to further configure the server. See [server-commands](https://www.papercut.com/help/manuals/ng-mf/common/tools-server-command/).