<img alt=upload2cloud src="img/up2cloud.png"/>

# upload2cloud

+ free opensource cloud disk uploader.
+ easy way upload files to cloud storages from command line / *nix shell.
+ is simple webdav linux console client 
+ suitable for any webdav storage.

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

    wget https://github.com/hyphop/upload2cloud/blob/master/dl/upload2cloud && chmod 0777 upload2*

## Yandex Drive

    wget -O upload2cloud-yandex https://github.com/hyphop/upload2cloud/blob/master/dl/upload2cloud && chmod 0777 upload2*

## 4shared.com

    wget -O upload2cloud-4shared https://github.com/hyphop/upload2cloud/blob/master/dl/upload2cloud && chmod 0777 upload2*

## Box.com

    wget -O upload2cloud-box.com https://github.com/hyphop/upload2cloud/blob/master/dl/upload2cloud && chmod 0777 upload2*

# Flexible custom install

same downloaded `upload2cloud`, and just make additionalt symlinks to `upload2cloud` as below

    wget https://github.com/hyphop/upload2cloud/blob/master/dl/upload2cloud && chmod 0777 upload2*
    ln -s upload2cloud upload2cloud-yandex
    ln -s upload2cloud upload2cloud-4shared
    ln -s upload2cloud upload2cloud-box.com
    ...
    ln -s upload2cloud upload2cloud-YOUR_SERVICE_NAME










