# home-container

My alpine based "docker virtual machine" that runs an sshd and has the needed base utils for the really minimal things I do:

- rsync
- tmux
- ssh

Its curently configured to as a small home dir that we can mount the needed directories. The home directory has a .ssh dir and assumes the rest of your dotfiles will come in via git.

I had originally tried to make it able to mount a home directory but ran into issues with permissions off my synology...


## To Use:
1.  Check/set the needed build args
    ```
    ARG USERNAME=kazin
    ARG UID=1028
    ARG GROUPNAME=users
    ARG SSHD_PORT=2229
    ```
2.  Copy over appropriate `authorized_keys` file to root of repo

3.  Build and save image to `home-container.tgz`

    ```
    make VERSION=1.0.0 save
    ```

4.  Upload Image up to synology




## To Develop:

Two terminals (I use tmux)

### Server

    make && docker run -it -p 2229:2229/tcp -v /Users/richardgutierrez:/home/kazin/home --entrypoint="/usr/sbin/sshd" home.thirteenjunes.com/kazin/home-container:latest -D -d


### Client

    ssh-keygen -R '[localhost]:2229' && ssh kazin@localhost -p 2229
