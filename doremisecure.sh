#!/bin/bash

#------Config------
encryption=openssl # zip, openssl (gpg and 7z to be added)
format_zip=doremyzip
format_openssl=doremy
zip_level=0 # 0-9, 0 recommended to disable compression
cipher=aes256 # "openssl enc -ciphers" for a full list of available ciphers
folder="Safe Folder" # If the folder name is "current", the script will analyze the current directory instead
#------------------

function encrypt ()  {
case $encryption in
zip)
    if [[ $1 != ".$format_zip" ]]
    then
        zip -$3 -v -r -P "$2" "$1.$format_zip" "$1"
        rm -r "$1"
    fi
;;
gpg)
;;
openssl)
    if [[ $1 != ".$format_openssl" ]]
    then
        if [[ -d $1 ]]
        then
            zip -0 -r -q "$1.zip" "$1"
            openssl enc -e -in "$1.zip" -k "$2" -pbkdf2 -$cipher -out "$1.zip.$format_openssl"
        else
            openssl enc -e -in "$1" -k "$2" -pbkdf2 -$cipher -out "$1.$format_openssl"
        fi
        rm -r "$1"
    fi
;;
esac
}

function decrypt () {
case $encryption in
zip)
    if [[ $1 == ".$format_zip" ]]
    then
        unzip -P "$2" "$1"
        rm -r "$1"
    fi
;;
gpg)
;;
openssl)
    if [[ $1 == ".$format_openssl" ]]
    then
        noformat=$(basename "$1" ".$format_openssl")
        openssl enc -d -in "$1" -k "$2" -pbkdf2 -$cipher -out "$noformat"
        if [[ $1 == *".zip"* ]]
        then
            unzip "$noformat"
            rm -r "$noformat"
        fi
        rm -r "$1"
    fi
;;
esac
}

if (( $zip_level < 0 ))
then
    zip_level=0
elif (( $zip_level > 9 ))
then
    zip_level=9
fi

if [[ $(openssl enc -ciphers) != *"$cipher"* ]]
then
    cipher=aes256
fi

if [[ $1 == d || $1 == e ]]
then
    if [[ -d $folder ]]
    then
        ready=1
    else
        echo "The defined safe directory does not exist, change the configuration inside the script"
        ready=0
    fi
fi

if [[ $ready == 1 ]]
then
case $1 in
d)
    echo "Input password"
    read -s password
    if [[ $folder != "current" ]]
    then
        cd "$folder"
    fi
    for i in *
    do
        decrypt $i $password
    done
;;
e)
    echo "Input password"
    read -s password
    echo "Repeat password"
    read -s password2

    if [[ $folder != "current" ]]
    then
        cd "$folder"
    fi

    if [[ $password == $password2 ]]
    then
        for i in *
        do
            if [[ $i != "doremisecure.sh" ]]
            then
                encrypt $i $password $zip_level
            fi
        done
    else
        echo "Passwords do not match"
    fi
;;
*)
        echo "Secure Folder Version 0.6.1"
        echo "Usage: securefolder.sh [option]"
        echo "Options:"
        echo "h    Help documentation"; echo "e    Encrypt a file/folder"; echo "d    Decrypt a file/folder"
;;
esac
fi
