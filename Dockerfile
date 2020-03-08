FROM alpine:latest

ARG USERNAME=kazin
ARG UID=1028
ARG GROUPNAME=users
ARG SSHD_PORT=2229

#
RUN apk add --no-cache \
    bash bash-completion grep readline less curl coreutils findutils rsync\
    openssh tmux git \
    # setup user
    && adduser -h /home/${USERNAME} -H -s /bin/bash -D -G ${GROUPNAME} -u ${UID} ${USERNAME}\
    # set password to x as it defaults to ! which means "inactive"
    && echo ${USERNAME}:x | chpasswd -e\
    # default home dir setup is sticky...it scared me so I did the below
    && mkdir /home/${USERNAME} && chmod 755 /home/${USERNAME} && chown ${USERNAME}:${GROUPNAME} /home/${USERNAME}\
    && mkdir /home/${USERNAME}/.ssh && chmod 700 /home/${USERNAME}/.ssh && chown ${USERNAME}:${GROUPNAME} /home/${USERNAME}/.ssh\
    #configuring the sshd...only allow USERNAME and key's only
    #(you can always exec into the running container if needed)
    && sed -i "/#Port 22/c Port ${SSHD_PORT}" /etc/ssh/sshd_config \
    && sed -i '/#PermitRootLogin/c PermitRootLogin no' /etc/ssh/sshd_config \
    && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo "AllowUsers ${USERNAME}" >> /etc/ssh/sshd_config \
    # need to generate a host key
    && ssh-keygen -A

# copy over a local authorized keys with the needed 'key'
COPY --chown=${USERNAME}:${GROUPNAME} authorized_keys /home/${USERNAME}/.ssh

EXPOSE ${SSHD_PORT}
ENTRYPOINT ["/usr/sbin/sshd", "-D"]