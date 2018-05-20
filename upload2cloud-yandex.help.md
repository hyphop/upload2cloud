
# upload2cloud-yandex ( based on [upload2cloud](https://github.com/hyphop/upload2cloud/) )

easy way upload files to cloud storage
from command line / shell, )

its simple webdav console client suitable for any webdav storage

# USAGE 

    upload2cloud-yandex [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, DIR, verbose ] upload2cloud-yandex

default values

+ ENV{DST}: "https://webdav.yandex.com" - webdav dst url - automate by name
+ ENV{CURL}: "curl" - curl binary - autodetect
+ ENV{DIR}: "/" - remote dir

# VERBOSE RUN & DEBUG

    verbose=-v upload2cloud-yandex

# CONFIG && config search PATH

./upload2cloud-yandex.conf => .upload2cloud-yandex.conf => ~/.upload2cloud-yandex.conf

its simple curl config format
configure user:password credential there 

# USER CONFIG EXAMPLES

    -H "Authorization: Basic d2h5LWFyZTp5b3UtZG9pbmc="
or

    -u user:password

# SOURCE

https://github.com/hyphop/upload2cloud

# INSTALL

    wget https://raw.githubusercontent.com/hyphop/upload2cloud/master/upload2cloud-yandex \
    && chmod 0777 upload2cloud-yandex

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##

