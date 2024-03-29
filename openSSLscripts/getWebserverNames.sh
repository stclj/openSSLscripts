#!/usr/bin/env bash
#
# getWebserverNames.sh - print certificate details of (web)server
#
# should run on Linux and MacOS
#
# usage: getWebserverNames.sh <server-name-or-ip> [<SSL-port>]
#
#        <server-name-or-ip> : name or IP address of webserver
#        <SSL-port>          : optional, destination port
#                              default = 443
#                              if 25, STARTTLS will be used
#
# This script can be found at: https://github.com/stclj/openSSLscripts

# Check if server is specified. If not print usage message
if [ -z "$1" ] ; then
   echo "Missing server name or address !" >&2
   echo "Usage: $0 <name or ip-address> [<port>]" >&2
   echo "" >&2
   exit 1
fi

# Check if port is given and set variables
EXTRAOPTS=""

if [ -n "$2" ] ; then
   SERVERPORT="$2"
   case $SERVERPORT in
     21)   EXTRAOPTS="$EXTRAOPTS -starttls ftp" ;;
     25)   EXTRAOPTS="$EXTRAOPTS -starttls smtp" ;;
     110)  EXTRAOPTS="$EXTRAOPTS -starttls pop3" ;;
     143)  EXTRAOPTS="$EXTRAOPTS -starttls imap" ;;
   esac
else
   SERVERPORT="443"
fi

SERVERADDRESS="$1"

# check if provided address is valid, if command "getent" is available
#   "getent" uses the gethostbyname function and respects /etc/hosts, if configured in /etc/nsswitch.conf
#   while "host", "dig" and "nslookup" use only DNS queries

if which getent 2>/dev/null >/dev/null ; then
   getent ahosts "$SERVERADDRESS" 2>/dev/null >/dev/null
   case "$?" in
     0)   # test was successfull
          ;;
     1)   echo "Test command \"getent\" does not support the database \"ahosts\" !" >&2
          echo "This script can run without the test, if you comment it out." >&2
          exit 1
          ;;
     2)   echo "Unknown server address \"$SERVERADDRESS\" !" >&2
          exit 1
          ;;
     127) # this error should never hit, because we tested if "getent" is in the path
          # in the outer if statement
          echo "Test command \"getent\" not found !" >&2
          echo "This script can run without the test, if you comment it out." >&2
          exit 1
          ;;
     *)   echo "Unknown error in test command \"getentahosts $SERVERADDRESS\" !" >&2
          echo "This script can run without the test, if you comment it out." >&2
          exit 1
          ;;
   esac
   # if the test with getent does not work for you comment out this section
   # ending here
fi

# sed has different options on Linux and MacOS, so we have to check which it is
if sed --version 2>/dev/null | head -1 | grep -q GNU ; then
   GNUSED="true"
else
   GNUSED=""
fi

# connect with openssl including certificate output,
# decode it's values and pritty print them
echo "" |
openssl s_client $EXTRAOPTS -connect $SERVERADDRESS:$SERVERPORT -servername $SERVERADDRESS 2>/dev/null |
openssl x509 -noout -text |
if [ $GNUSED ] ; then
   # it's Linux (GNU sed):
   sed -n -e "s/^ \+\(Subject: .*\)/\1/p" \
          -e "s/^ \+Not After : /Up to:   /p" \
          -e "/^ \+X509v3 Subject Alternative Name:/{n;s/^ \+/SAN:     /;p}" \
          -e "s/^ \+\(Issuer:\)\+\(.*\)/\1 \2/p" |
   sed "s/,/\n        /g"
   # Last sed breaks the long lines at comma (,) and indents the rest
else
   # it's MacOS, so it looks a bit more complicated:
   sed -nE -e "s/^ +(Subject: .*)/\1/p" \
           -e "s/^ +Not After : /Up to:   /p" \
           -e "/^ +X509v3 Subject Alternative Name:/{n;s/^ +/SAN:     /p;}" \
           -e "s/^ +(Issuer:)+(.*)/\1 \2/p" |
   sed     $'s/,/\\\n        /g'
   # Last sed breaks the long lines at comma (,) and indents the rest
   # The $'...' expands the escape sequences in the quote:
   #   - \\ converts to a real \
   #   - \n converts to a newline
   #     \<newline> is send to sed
   #   - it needs to be ecaped for sed, so sed won't end but use the <newline>
fi

# connect a second time to get offered certificate chain:

echo "presented certificate chain:"

echo "" |
openssl s_client $EXTRAOPTS -showcerts -connect $SERVERADDRESS:$SERVERPORT -servername $SERVERADDRESS 2>/dev/null |
if [ $GNUSED ] ; then
   # it's Linux (GNU sed):
   sed -n "s|^\( *[0-9]\+ s:\).*/\(CN=[^/]\+\)\(/.*\)*$|        \1 \2|p"
   # Last sed breaks the long lines at comma (,) and indents the rest
else
   # it's MacOS, so it looks a bit more complicated:
   sed -nE "s|^( *[0-9]+ s:).*/(CN=[^/]+)(/.*)*$|        \1 \2|p"
   # Last sed breaks the long lines at comma (,) and indents the rest
fi

