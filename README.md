## Description
DoremiSecure encrypts the files inside a fixed folder, making it fast and convenient to mass encrypt each file individually with the intention of making it a "secure folder"

## How to use
Download doremisecure.sh and execute it. Open the script and change the configuration in the first lines to customise the tool to your needs

## Configuration
### encryption
Choose the encryption utility. Currently it can either be openssl or zip

### format_zip
The file extension for encrypted zip files

### format_openssl
The file extension for encrypted files using OpenSSL

### zip_level
The compression level of zip archives, ranging from 0 (none) to 9 (maximum)

### cipher
The encryption mode for OpenSSL. Type the command "openssl enc -ciphers" for a full list of available ciphers

### folder
The folder which will be used for encryption. If set to "current", the script will analyze the directory where it's located at

## Requirements
Bash, zip/unzip, OpenSSL, GPG (to be added), coreutils or busybox
