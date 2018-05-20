
# upload2cloud based on [upload2cloud](https://github.com/hyphop/upload2cloud/)

easy way upload files to cloud storage
from command line / shell, )

its simple webdav console client suitable for any webdav storage

# USAGE 

    upload2cloud [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, DIR, verbose ] upload2cloud

default values

+ ENV{DST}: "https://my.webdav.server" - webdav dst url - automate by name
+ ENV{CURL}: "curl" - curl binary - autodetect
+ ENV{DIR}: "/" - remote dir

# VERBOSE RUN & DEBUG

verbose=-v upload2cloud

# CONFIG && config search PATH

./upload2cloud.conf => .upload2cloud.conf => ~/.upload2cloud.conf

its simple curl config format
configure user:password credential there 

# CONFIG EXAMPLES

    -H "Authorization: Basic d2h5LWFyZTp5b3UtZG9pbmc="
or

    -u user:password

# SOURCE & INSTALL

https://github.com/hyphop/upload2cloud - source page 

    wget https://raw.githubusercontent.com/hyphop/upload2cloud/master/upload2cloud
    chmod 0777 upload2cloud

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##

