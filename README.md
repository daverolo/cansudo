# CanSudo.sh

Bash script to check whether or not the current user can sudo **without entering a password**.

## Example

```
bash cansudo.sh
```
> Run the command above with users that have different settings in `/etc/sudoers`!

## Exit codes

Code | Type | Description
---------|----------|---------
 0 | SUCCESS | The user is in sudo group **and** can use sudo without password
 1 | FAIL | The user can not use sudo at all because he is not in sudo group
 2 | FAIL | The user can use sudo but requires to input a password

# Important

Currently only tested with bash & may not work with zsh on mac!

# Credits

Resources i found during research wich helped develop this script:

* [Sudo guide on jumpcloud.com](https://jumpcloud.com/blog/how-to-create-a-new-sudo-user-manage-sudo-access-on-ubuntu-20-04)
* [How to timeout a sudo password prompt](https://askubuntu.com/a/401536)
* [Examples how to hide the output of a backgroud process](https://stackoverflow.com/a/8220110/10672117)
