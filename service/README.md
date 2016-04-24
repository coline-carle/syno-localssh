# Services running inside container via runit

## sshd

The sshd process is started with a logger to send output to directory `/var/log/sshd/`. If the host keys do not exist, then `ssh-keygen -A` is executed to provide the different host key variants.


## rsyncd

The rsyncd process is started with a logger to send output to directory `/var/log/rsyncd/`. The process is configured based on the file `/etc/rsyncd.conf`.


## syslog

The syslog process is started with all output redirected to `/dev/stdout`. Therefore anything sent to syslog will be visible using the `docker logs` command.
