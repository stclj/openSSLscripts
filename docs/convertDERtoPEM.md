# convertDERtoPEM.sh

## Porpose

This bash script converts a SSL certificate from DER-format into PEM-format.
DER is a binary format primarily used by Micosoft, PEM is an ASCII representation for binary data.

## Command format

```bash
convertDERtoPEM.sh <DER-filename> [<PEM-filename>]
```

* `<DER-filename>` is the name of a file containing the DER encoded certificate.
* `<PEM-filename>` is the name of a file the PEM encoded certificate is written to.
  If this is ommitted, the PEM encoded certificate is send to stdout.
* **This scipt won't override the output file!*
  If the `<PEM-filename>` already exist, the script will stop.

## Some explanations

### `openssl x509`

* This command will handle certificates, e.g. convert them or displays information coded into the certificate.
* It as options for the handling of it's input
  * `-in <filename>` set the filename from which to fetch the certificate.
    If ommitted it will use stdin.
  * `-inform PEM` (default if ommitted) expects the certificate in PEM format.
  * `-inform DER` expects the certificate in DER format.
* And options for the handling of it's output
  * `-out <filename>` set the filename where to write the certificate to
    If ommitted it will use stout.
  * `-outform PEM` (default if ommitted) writes the in PEM format.
  * `-outform DER` writes the certificate in DER format.

