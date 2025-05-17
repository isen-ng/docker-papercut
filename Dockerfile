# Use a build stage so users don't have to download the heavy installer
FROM --platform=linux/x86_64 ubuntu:xenial AS build

RUN apt-get update

###### Install papercut

# Install packages required for papercut
RUN apt-get install -y cups curl cpio perlbrew

# Download papercut
ENV PAPERCUT_MAJOR_VER=21.x
ENV PAPERCUT_VER=21.0.4.57587
ENV PAPERCUT_DOWNLOAD_URL=https://cdn1.papercut.com/web/products/ng-mf/installers/mf/${PAPERCUT_MAJOR_VER}/pcmf-setup-${PAPERCUT_VER}.sh
RUN curl -L "${PAPERCUT_DOWNLOAD_URL}" -o /pcmf-setup.sh && chmod a+rx /pcmf-setup.sh

# Create user && install papercut
RUN groupadd papercut
RUN useradd --create-home --gid papercut --home /papercut papercut
RUN runuser -l papercut -c "/pcmf-setup.sh --non-interactive" && rm -f /pcmf-setup.sh && /papercut/MUST-RUN-AS-ROOT

# Stopping Papercut services before capturing image
RUN /etc/init.d/papercut stop && /etc/init.d/papercut-web-print stop

# ----------------------------------------

FROM --platform=linux/x86_64 ubuntu:xenial

RUN apt-get update

###### Install CUPS

# install cups
RUN apt-get install -y cups cups-filters cups-client whois sudo

# create admin user cups
# add user to lp, lpadmin
# set password to cups
# disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --password=$(mkpasswd cups) \
  cups \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# create default printer by writing to the conf file
# this file is needed by papercut to monitor stuff
COPY printers.conf /etc/cups/printers.conf

COPY cups.conf /etc/cups/cupsd.conf
EXPOSE 631


###### Copy papercut from build

# Create papercut user
RUN groupadd papercut
RUN useradd --create-home --gid papercut --home /papercut papercut

# Install packages required for papercut
RUN apt-get install -y cups curl cpio perlbrew

# Copy from build stage
# It is important to also include `--chown=papercut:papercut` otherwise a separate command
# will create a layer as large as the folder (which is 800+MB)
COPY --from=build --chown=papercut:papercut /papercut /papercut

# Install various stuff (run this after installing cups to auto-configure cups)
RUN /papercut/MUST-RUN-AS-ROOT

# Stopping Papercut services before capturing image
RUN /etc/init.d/papercut stop && /etc/init.d/papercut-web-print stop

# so that we can easily print a test file
# docker exec <container> runuser -l <user> "lp -d nul /lorem-ipsum.pdf"
COPY lorem-ipsum.pdf /

COPY server.properties /papercut/server/server.properties
EXPOSE 9191 9192 9193


###### Install SSH server to accept papercut server-commands

RUN apt-get -y install openssh-server
RUN echo "    PasswordAuthentication yes" >> /etc/ssh/ssh_config
RUN mkdir -p /var/run/sshd

# Create server-command user, add to sudo, papercut, lp and lpadmin groups.
# No password to sudo
RUN useradd --groups=sudo,papercut,lp,lpadmin server-command
RUN echo "server-command:server-command" | chpasswd
RUN sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Ensure papercut group (including server-command) can access server-command binary
RUN chmod g+rx /papercut/server/bin

EXPOSE 22


###### Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

WORKDIR /papercut
ENTRYPOINT ["/entrypoint.sh"]
