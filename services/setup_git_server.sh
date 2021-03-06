
#!/bin/bash

# This script is used to set up a git server so that you can host your own Repos. To add your public -
key to the SSH authorised keys use the -pk flag.

TEMP=`getopt -o p:r: --long public_key:repo_name: -- "$@"`
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -p|--public_key)
            public_key=$2 ; shift 2;;
        -r|--repo_name)
            repo_name=$2 ; shift 2;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Adding user and setting up ssh
apt install git apache2
adduser git

mkdir /home/git/.ssh && chmod 700 /home/git/.ssh
touch /home/git/.ssh/authorized_keys && chmod 600 /home/git/.ssh/authorized_keys

# Adding Public Key
echo "
ssh-rsa $public_key gsg-keypair
" > /home/git/.ssh/authorized_keys

# Make Git repos
mkdir -p /var/www/git/$repo_name.git
cd /var/www/git/$repo_name.git
git init --bare
chown -R git:git /var/www/git 

echo "Congrats your git server is good to go. Just push your local repo to git@gitserver:/var/www/git/$repo_name.git"

