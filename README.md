<img alt=upload2cloud src="img/up2cloud.png"/> [![Build Status](https://travis-ci.com/hyphop/upload2cloud.svg?branch=master)](https://travis-ci.com/hyphop/upload2cloud)

# upload2cloud - cloud disk uploader

+ easy way upload files to cloud storages from command line / *nix shell, without GUI
+ is simple webdav linux console client 
+ universal & suitable for any webdav storage
+ just one file, 4K only
+ ideal for automate usage
+ free opensource

# Checked & Tested Storage Provides

PROVIDER | FREE | SERVER |Checked
--- | --- | --- | ---
[yandex](https://disk.yandex.com)	| 10 GB	| webdav.yandex.com/ | ok
[4shared](https://4shared.com)	| 10 GB	| webdav.4shared.com/ | ok
[Box](https://box.com) | 10 GB	| dav.box.com/dav | ok
[CloudMe](https://cloudme.com)	| 3 GB	| webdav.cloudme.com/ | dont work

you can check another storage providers , 
make some customization and fork [upload2cloud](https://github.com/hyphop/upload2cloud)

# Usage 
    
    upload2cloud [ DIRS | FILES ]
    
# Get Source 

    git clone https://github.com/hyphop/upload2cloud

# Get && Install

just one line get && install

    wget https://raw.githubusercontent.com/hyphop/upload2cloud/master/dl/upload2cloud && chmod 0777 upload2*

# Custom providers install

just make symlinks `upload2cloud-YOUR_SERVICE_NAME` to `upload2cloud` as below

    ln -s upload2cloud upload2cloud-yandex
    ln -s upload2cloud upload2cloud-4shared
    ln -s upload2cloud upload2cloud-box.com
    ...
    ln -s upload2cloud upload2cloud-YOUR_SERVICE_NAME

## Yandex Disk

    wget -O upload2cloud-yandex https://raw.githubusercontent.com/hyphop/upload2cloud/master/src/upload2cloud && chmod 0777 upload2*

## 4shared.com

    wget -O upload2cloud-4shared https://raw.githubusercontent.com/hyphop/upload2cloud/master/src/upload2cloud && chmod 0777 upload2*

## Box.com

    wget -O upload2cloud-box.com https://raw.githubusercontent.com/hyphop/upload2cloud/master/src/upload2cloud && chmod 0777 upload2*


# Just another way to install

    curl -kL https://git.io/vpjn6 > upload2cloud

# Author 

    ## hyphop ##

