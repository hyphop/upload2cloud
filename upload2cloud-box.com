#!/bin/sh

## hyphop ##

PROG="$(basename "$0")"
REP="upload2cloud"
SRC_BASE="https://raw.githubusercontent.com/hyphop/$REP/master"

[ "$DIR" ] || DIR=""
DIR="$DIR/"

EXTRA="( based on [upload2cloud](https://github.com/hyphop/upload2cloud/) )"
[ "$CURL" ] || CURL="curl"

COPTS="$COPTS -# \
    $verbose -o- \
    -g -i \
    -L \
    -K-
"

[ "$DST" ] || {
    case $PROG in
	## disk.yandex.com
	yandex*|*yandex)
	DST="https://webdav.yandex.com"
	;;
	## box.com
	*box.com)
	DST=https://dav.box.com/dav
	;;
	## 4shared.com
	4shared*|*4shared)
	DST=https://webdav.4shared.com
	;;
	## cloudme.com
	## https://www.cloudme.com/en/webdav

	*cloudme)
	DST=https://webdav.cloudme.com
	;;
	*)
	DST="https://my.webdav.server"
	;;
    esac
}


about(){


echo "
# $PROG $EXTRA

easy way upload files to cloud storage from command line / *nix shell.
`$PROG` is simple webdav linux console client suitable for any webdav storage

# USAGE 

    $PROG [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, DIR, verbose ] $PROG

default values

+ ENV{DST}: \"$DST\" - webdav dst url - automate by name
+ ENV{CURL}: \"$CURL\" - curl binary - autodetect
+ ENV{DIR}: \"$DIR\" - remote dir

# VERBOSE RUN & DEBUG

    verbose=-v $PROG

# CONFIG SEARCH PATHS

this file just simple **curl config** ( more details there *man curl* )
you can configure *user:password* credential there 

./$PROG.conf => .$PROG.conf => ~/.$PROG.conf


# USER CONFIG EXAMPLES

    -H \"Authorization: Basic d2h5LWFyZTp5b3UtZG9pbmc=\"
or

    -u \"user:password\"

# SOURCE

https://github.com/hyphop/$REP

# INSTALL

    wget $SRC_BASE/$PROG
    chmod 0777 $PROG

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##
"

}

#verbose="-v"
#verbose="-i"


[ "$1" ] || {
    about
    exit 1
}

#LIST=
#DIRS=
#FILES=


for a in "$@" ; do
case $a in
    -h|--help)
    about
    exit 0
    ;;
    *)
    
    [ -e "$a" ] || {
	echo "[w] not exist source" >&2
	exit 1
    }
    echo "[i] upload source => $a"
    ;;
esac

done

CURL=`which $CURL`

[ ! "$CURL" -o ! -x "$CURL" ] && {
    echo "[E] curl not work / please check or install it" >&2
    exit 1
}

for CNF in     \
    "$0.conf"   \
    "$PROG.conf" \
    ".$PROG.conf" \
    ~/".$PROG.conf"\

do
#    echo "[i] chk cfg $CNF" >&2

    [ -e $CNF ] && {
	echo "[i] read config $CNF" >&2
	break;
    }
    CNF=""
done

[ "$user_password" ] || {
    [ "$user" ] && user_password="$user"
    [ "$password" ] && user_password="$user_password:$password"
}

echo "[i] WEBDAV URL: $DST" >&2

userpass(){
    echo -n "Enter ya-disk USER LOGIN: "
    read user
    echo -n "Enter ya-disk USER PASSWORD: "
    read passw
    user_password="$user:$passw"
}

[ "$CNF" ] || {
    echo -n "[e] config not found: " >&2
    about | grep "\.conf" >&2
    # make empty config
    CNF=~/.$PROG.conf
    echo "# $PROG - config" > $CNF
}


[ "$user_password" ] || {
    grep -E -q "^\-(u|H) " "$CNF" 2>/dev/null || {
    echo "[w] user not defined in $CNF" >&2
    userpass
    echo "[i] SAVE USER:PASS to $CNF" >&2
    echo "-u \"$user_password\"" >> $CNF
    }
}

urlencode(){
# url encode
    echo "$(curl -Gso /dev/null -w %{url_effective} --data-urlencode "$1" "" | cut -c 3-)"
}


anydir(){
    [ "$(find -L "$@" -type d 2>/dev/null)" ] && return 0
    return 1
}

anyfiles(){
    [ "$(find -L "$@" -type f 2>/dev/null)" ] && return 0
    return 1
}

readdir(){
cat "$CNF"
find -L "$@" -type d | while read d ; do
echo "[i] $d" >&2
echo "url = \"$DST/$DIR$(urlencode "$d")\"" 
done
}

readfiles(){
cat "$CNF"
find -L "$@" -type f | while read f ; do
S="$(stat -L -c%s "$f")"
echo "[i] $f ($S bytes)" >&2
echo "upload-file = \"$f\"
url = \"$DST/$DIR$(urlencode "$f")\"
"
done
}

PID=$$

## BEGIN

echo "[i] remote dir: $DIR" >&2
echo "[i] bin $CURL" >&2

#[ -d "$F" ] && {
anydir "$@" && {
echo "[i] UPLOAD DIRS" >&2

readdir "$@" | $CURL $COPTS \
    -i \
    -X MKCOL |  while read L ; do
    #echo "> $L" >&2
    # ok
    #HTTP/1.1 405 Method Not Allowed

    case "$L" in
	*409\ Conflict*)
        echo "\n[E] $L" >&2
	kill $PID
	exit 1
	;;
	*Unauthorized*)
        echo "\n[E] $L" >&2
	kill $PID
	exit 1
	;;
    esac

done

}

echo ""
anyfiles "$@" && {

echo "[i] UPLOAD FILES" >&2

readfiles "$@" | $CURL $COPTS \
    -f \
    -X PUT >/dev/null

}

# exit 0


