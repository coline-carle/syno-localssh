# SSH and RSYNC containerized for Synology NAS

The OpenSSH install provided with the Synology DSM is customized and often leads to many challenges when needing to rsync files over ssh to the NAS. After each upgrade you have to fight to get the setup working again.

With the introduction of Docker in DSM 5, it is easier to simply leverage a container to manage all the rsync and ssh configurations.

The image will include the following:

- openssh
- rsync
- runit
- bash
- non-system user for SSH access

## Configurations

### SSH keypair

**Example**

```bash
ssh-keygen -t rsa -b 4096 -f ./sshkey
```


### SSHD Config

Modify the example `sshd_config` file to set the `USERNAME` for the user allowed to ssh to the running container. Should be the same as the user account created within the image.


### RSYNCD Config

Modify the example `rsyncd.conf` file to configure the paths that are being made accessible for write or read. The paths should be the same paths as specified within the docker run command below.


## Building the image

```bash
USERNAME=myuser
PASSWORD=mypassword
sudo docker build -t myimagename .
```


## Running the image

```bash
sudo docker run -d --name mycontainername -v /a/host/path:/a/container/path -p "2222:22" myimagename
```

The volumes specified when running should map exactly to the entry(ies) specified within the `rsyncd.conf` file. The port mapping allows you to leverage another port to avoid conflicting with the SSH daemon running on the local NAS.


