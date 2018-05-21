
# upload2cloud-cloudme ( based on [upload2cloud](https://github.com/hyphop/upload2cloud/) )

easy way upload files to cloud storage from command line / *nix shell.
**upload2cloud-cloudme** is simple webdav linux console client suitable for any webdav storage

# USAGE 

    upload2cloud-cloudme [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, COPTS, DIR, verbose, test ] upload2cloud-cloudme

default values

+ ENV{DST}: "https://webdav.cloudme.com" - webdav dst url - automate by name
+ ENV{CURL}: "curl" - curl binary - autodetect
+ ENV{DIR}: "/" - remote dir

# VERBOSE RUN & DEBUG

    verbose=1 upload2cloud-cloudme

# CONFIG SEARCH PATHS

this file just simple **curl config** ( more details there *man curl* )
you can configure *user:password* credential there 

./upload2cloud-cloudme.conf => .upload2cloud-cloudme.conf => ~/.upload2cloud-cloudme.conf


# USER CONFIG EXAMPLES

    -H "Authorization: Basic d2h5LWFyZTp5b3UtZG9pbmc="
or

    -u "user:password"

# SOURCE

https://github.com/hyphop/upload2cloud

# INSTALL

    wget https://raw.githubusercontent.com/hyphop/upload2cloud/master/upload2cloud-cloudme && chmod 0777 upload2cloud-cloudme

or
    
    curl -kL https://git.io/vpjn6 > upload2cloud-cloudme && chmod 0777 upload2cloud-cloudme

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##

