
# upload2cloud-4shared ( based on [upload2cloud](https://github.com/hyphop/upload2cloud/) )

easy way upload files to cloud storage
from command line / *nix shell

its simple webdav linux console client suitable for any webdav storage

# USAGE 

    upload2cloud-4shared [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, DIR, verbose ] upload2cloud-4shared

default values

+ ENV{DST}: "https://my.webdav.server" - webdav dst url - automate by name
+ ENV{CURL}: "curl" - curl binary - autodetect
+ ENV{DIR}: "/" - remote dir

# VERBOSE RUN & DEBUG

    verbose=-v upload2cloud-4shared

# CONFIG SEARCH PATHS

./upload2cloud-4shared.conf => .upload2cloud-4shared.conf => ~/.upload2cloud-4shared.conf

this file just simple curl config ( more details there *man curl* )
you can configure *user:password* credential there 

# USER CONFIG EXAMPLES

    -H "Authorization: Basic d2h5LWFyZTp5b3UtZG9pbmc="
or

    -u user:password

# SOURCE

https://github.com/hyphop/upload2cloud

# INSTALL

    wget https://raw.githubusercontent.com/hyphop/upload2cloud/master/upload2cloud-4shared \
    && chmod 0777 upload2cloud-4shared

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##
