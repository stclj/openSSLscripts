#!/usr/bin/env bash
#
# convertDERtoPEM.sh - convert certificate in DER-format into PEM-format
#
# usage: convertDERtoPEM.sh <DER-filename> [<PEM-filename>]
#        <DER-filename> : name of file to import DER formatted certificate from
#        <PEM-filename> : name of file to write PEM formatted certificate to
#                         optional, if omitted show PEM on stdout
#
# This script can be found at: https://github.com/stclj/openSSLscripts

# Check if input file is specified and exist. If not print usage message

if [ -z "$1" ] ; then
   echo "Missing input filename !" >&2
   echo "Usage: $0 <DER-filename> [<PEM-filename>]" >&2
   echo "" >&2
   exit 1
else
   INPUTFILE="$1"
fi

if [ ! -f "$INPUTFILE" ] ; then
   echo "File \"$INPUTFILE\" does not exist !" >&2
   echo "Usage: $0 <DER-filename> [<PEM-filename>]" >&2
   echo "" >&2
   exit 1
fi

if [ -n "$2" ] ; then
   OUTPUTFILE="$2"
   OUTPUTOPTION="-out $OUTPUTFILE"
else
   OUTPUTOPTION=""
   # we send PEM output to stdout
fi

if [ -f "$OUTPUTFILE" ] ; then
   echo "Output files \"$OUTPUTFILE\" exist! Won't override it." >&2
   echo ""
   exit 1
fi

openssl x509 -in "$INPUTFILE" -inform DER \
        -outform PEM $OUTPUTOPTION

