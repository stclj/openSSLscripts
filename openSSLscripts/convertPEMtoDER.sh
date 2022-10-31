#!/usr/bin/env bash
#
# convertPEMtoDER.sh - convert certificate in PEM-format into DER-format
#
# usage: convertPEMtoDER.sh <PEM-filename> <DER-filename>
#        <PEM-filename> : name of file to import PEM formatted certificate from
#                         specify "-" to get PEM certificate from stdin
#        <DER-filename> : name of file to write DER formatted certificate to
#
# This script can be found at: https://github.com/stclj/openSSLscripts

# Check if in- and output files are specified

if [ -z "$1" ] ; then
   echo "Missing input filename !" >&2
   echo "Usage: $0 <PEM-filename> <DER-filename>" >&2
   echo "" >&2
   exit 1
else
   INPUTFILE="$1"
fi

if [ -z "$2" ] ; then
   echo "Missing output filename !" >&2
   echo "Usage: $0 <PEM-filename> <DER-filename>" >&2
   echo "" >&2
   exit 1
else
   OUTPUTFILE="$2"
fi

if [ "$INPUTFILE" == "-" ] ; then
   INPUTOPTION=""
   # we expect PEM formatted certificate on stdin
elif [ -f "$INPUTFILE" ] ; then
   INPUTOPTION="-in $INPUTFILE"
else
   echo "File \"$INPUTFILE\" does not exist !" >&2
   echo "Usage: $0 <DER-filename> [<PEM-filename>]" >&2
   echo ""
   exit 1
fi

if [ -f "$OUTPUTFILE" ] ; then
   echo "Output files \"$OUTPUTFILE\" exist! Won't override it." >&2
   echo ""
   exit 1
fi

openssl x509 $INPUTOPTION -inform PEM \
        -outform DER -out "$OUTPUTFILE"

