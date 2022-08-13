# CanSudo.sh 1.0.0

Bash script to check whether or not the current user can sudo **without entering a password**.

## Example

```
bash cansudo.sh
```
> Run the command above with users that have different settings in `/etc/sudoers`!

## Arguments

Argument | Required | Accepts Value | Description
---------|---------|----------|---------
 --version |  No | None | Returns script name and version
 -v |  No | None | Returns script name and version

## Exit Codes

Code | Type | Description
---------|----------|---------
 0 | SUCCESS | The user is in sudo group **and** can use sudo without password
 1 | FAIL | The user can not use sudo at all because he is not in sudo group
 2 | FAIL | The user can use sudo but requires to input a password

# Important

1. Currently only tested with bash on Ubuntu 20.04
1. Script may not work with zsh on Mac or other shells/OS
1. You may have to adjust the `timeout` value on busy systems (see `ESSENTIALS` section in [cansudo.sh](cansudo.sh)
1. Still a bit _hacky_ solution - use at your own risk

# Credits

Resources i found during research wich helped develop this script:

* [Sudo guide on jumpcloud.com](https://jumpcloud.com/blog/how-to-create-a-new-sudo-user-manage-sudo-access-on-ubuntu-20-04)
* [How to timeout a sudo password prompt](https://askubuntu.com/a/401536)
* [Examples how to hide the output of a backgroud process](https://stackoverflow.com/a/8220110/10672117)

> I am not associated in any form with the mentioned resources.
