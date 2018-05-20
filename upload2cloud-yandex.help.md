
# upload2cloud-yandex

easy way upload files to cloud storage
from command line / shell

its simple webdav console client suitable for any webdav storage

# USAGE 

    upload2cloud-yandex [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, DIR ] upload2cloud-yandex

default values

+ ENV{DST}: "https://webdav.yandex.com" - webdav dst url - automate by name
+ ENV{CURL}: "curl" - curl binary - autodetect
+ ENV{DIR}: "/" - remote dir
...

# CONFIG && config search PATH

./upload2cloud-yandex.conf => .upload2cloud-yandex.conf => ~/.upload2cloud-yandex.conf

its simple curl config format
configure user:password credential there 

# CONFIG EXAMPLES

    -H "Authorization: Basic YWNjasdasdMHVudC5mcmt3Z2Z2tsYWJvcWs="
or
    -u user:password

# SOURCE & INSTALL

https://github.com/hyphop/upload2cloud-yandex - source page 

    wget https://raw.githubusercontent.com/hyphop/upload2cloud-yandex/master/upload2cloud-yandex
    chmod 0777 upload2cloud-yandex

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##

