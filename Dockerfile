FROM alpine:3.3

# Required to install runit (our process manager)
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update \
      bash \
      openssh \
      rsync \
      runit@testing \
    && rm -rf /var/cache/apk/*

# load the start scripts for each of the services installed
COPY service /etc/service/
COPY sshd_config /etc/ssh/sshd_config
COPY rsyncd.conf /etc/rsyncd.conf

# specify the build args required to build the image
ARG USERNAME
ARG PASSWORD

# add user to make sure the ID get assigned consistently
# the user is added with no password but then a change password
# is done so that login via ssh key later but login via password
# is disabled in the provided sshd_config file.
RUN adduser -D -s /bin/bash -G users ${USERNAME} && echo '${USERNAME}:${PASSWORD}' | chpasswd

# Add the users ssh keys as that is the only way to log in
COPY sshkey /home/${USERNAME}/.ssh/id_rsa
COPY sshkey.pub /home/${USERNAME}/.ssh/id_rsa.pub

# make sure the permissions are set and our authorized_keys is set
# and that the user is the owner since root performed all previous
# actions above.
RUN chmod 400 /home/${USERNAME}/.ssh/id_rsa \
  && chmod 600 /home/${USERNAME}/.ssh/id_rsa.pub \
  && cp /home/${USERNAME}/.ssh/id_rsa.pub /home/${USERNAME}/.ssh/authorized_keys \
  && chown -R ${USERNAME}:users /home/${USERNAME}/.ssh

EXPOSE 22

CMD ["runsvdir", "/etc/service"]
