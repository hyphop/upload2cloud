#!/bin/sh

## hyphop ##


PROG="$(basename "$0")"
REP="upload2cloud"
SRC_BASE="https://raw.githubusercontent.com/hyphop/$REP/master/src"
## https://git.io/
SHORT_LINK=https://git.io/vpjKe

[ "$DIR" ] || DIR=""
DIR="$DIR/"

EXTRA=" [upload2cloud](https://github.com/hyphop/upload2cloud/) "
[ "$CURL" ] || CURL="curl"

COPTS="-# -o- -g -i -L -K- $COPTS"

HTTPS="https://"

# CURL
#--connect-to <HOST1:PORT1:HOST2:PORT2>
#--resolve <host:port:address>

#verbose=1 COPTS="-w @curl-format" OUTPUT="/dev/stdout"

[ "$OUTPUT" ] || OUTPUT="/dev/null" ##  /dev/stdout /dev/stderr
[ "$DST" ] || {
    case $PROG in
	## disk.yandex.com
	yandex*|*yandex)
	DST="webdav.yandex.com"
	;;
	## box.com
	*box.com)
	DST="dav.box.com/dav"
	;;
	## 4shared.com
	4shared*|*4shared)
	DST="webdav.4shared.com"
	;;
	## cloudme.com
	## https://www.cloudme.com/en/webdav

	*cloudme)
	DST="webdav.cloudme.com"
	COPTS="$COPTS --digest"
	;;
	*)
	DST="my.webdav.server"
	;;
    esac
}

about(){


echo "
# $PROG $EXTRA

easy way upload files to cloud storage from command line / *nix shell.
**$PROG** is simple webdav linux console client suitable for any webdav storage

# USAGE 

    $PROG [ DIRS | FILES ]

# VARS

any vars defines as ENV variables

    [ user, password, user_password, DST, CURL, COPTS, DIR, verbose, test ] $PROG

default values

+ ENV{DST}: \"$DST\" - webdav dst url - automate by name
+ ENV{CURL}: \"$CURL\" - curl binary - autodetect
+ ENV{DIR}: \"$DIR\" - remote dir

# VERBOSE RUN & DEBUG

    verbose=1 $PROG

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

    wget $SRC_BASE/$PROG && chmod 0777 $PROG

or
    
    curl -kL $SHORT_LINK > $PROG && chmod 0777 $PROG

# REQUIRED

+ curl

# AUTHOR

    ## hyphop ##
"

}

[ "$verbose" ] && {
    case "$verbose" in
	0|no|false|NO|FALSE)
	;;
	i)
	COPTS="$COPTS -i"
	;;
	*)
	COPTS="$COPTS -v"
	;;
    esac
}


[ "$1" ] || {
    about
    exit 1
}


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
#https://orrsella.com/2014/10/06/http-request-diagnostics-with-curl/

    echo "$(curl -Gso /dev/null -w %{url_effective} --data-urlencode "$1" "" | cut -c 3-)"

}

geturl(){
    
    # try TO DO this job without perl ))))
    p=${1#https://}
    p=${p#http://}
    s="$(curl -Gso /dev/null -w %{url_effective} --data-urlencode "$2" "" | cut -c 3-)"
    echo -n $HTTPS
    echo "$p$s" | sed -e 's/%2F/\//g' | sed -e 's/\/\+/\//g'

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
echo ""
find -L "$@" -type d | while read d ; do
echo "[i] $d" >&2
#echo "url = \"$DST/$DIR$(urlencode "$d")\"" 
echo "url = \"$(geturl "$DST" "/$DIR/$d")\""
#echo "--next"
echo ""
done
}

readfiles(){
cat "$CNF"
echo ""
find -L "$@" -type f | while read f ; do
S="$(stat -L -c%s "$f")"
echo "[i] $f ($S bytes)" >&2
echo "upload-file = \"$f\""
#echo "url = \"$DST/$DIR$(urlencode "$f")\""
echo "url = \"$(geturl "$DST" "/$DIR/$f")\"" 
done
}

PID=$$

## BEGIN

BEGIN=`date +%s`

echo "[i] remote dir: $DIR" >&2

[ "$verbose" ] && echo "[i] bin $CURL" >&2
[ "$verbose" ] && echo "[i] CURL OPTS $COPTS" >&2

getlist(){
cat $CNF
echo ""
echo "url = \"$DST/$DIR\"" 
}

## JUST FOR TEST 
[ "$GET" ] && {

getlist | $CURL $COPTS \
    -i \
    -H "Depth: 1" \
    -X PROPFIND
exit 0
}

#[ -d "$F" ] && {
anydir "$@" && {
echo "[i] UPLOAD DIRS" >&2

[ "$test" ] && readdir "$@"
[ "$test" ] || \
readdir "$@" | $CURL $COPTS \
    -i \
    -X MKCOL |  while read L ; do
    #echo "> $L" >&2
    # ok
    #HTTP/1.1 405 Method Not Allowed

    case "$L" in
	*409\ Conflict*)
        echo "\n[E] $L" >&2
	kill -TERMP $PID
	sleep 1
    	exit 1
	;;
	*Unauthorized*)
        echo "\n[E] $L" >&2
	kill -TERM $PID
	sleep 1
	exit 1
	;;
    esac

done

}

anyfiles "$@" && {

echo "[i] UPLOAD FILES" >&2


[ "$test" ] && readfiles "$@"
[ "$test" ] || \
readfiles "$@" | $CURL $COPTS \
    -f \
    -X PUT >$OUTPUT

#HTTP/1.1 204 No Content

}

END=`date +%s`

DURATION=$((END - BEGIN))

echo "[i] upload duration time: $DURATION s"

# exit 0


