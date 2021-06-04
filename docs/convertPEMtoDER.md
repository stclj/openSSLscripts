# convertPEMtoDER.sh

## Porpose

This bash script converts a SSL certificate from PEM-format into DER-format.<br>
DER is a binary format primarily used by Micosoft, PEM is an ASCII representation for binary data.

## Command format

```bash
convertPEMtoDER.sh <PEM-filename> <DER-filename>
```

* if `<PEM-filename>` is "`-`" (the minus sign), the PEM certificate is expected on stdin,<br>
  otherwise it must be a file containing the PEM encoded certificate.
* `<DER-filename>` is the name of the file the DER encoded certificate is written to.
* **This scipt won't override the output file!**
  If the `<DER-filename>` already exist, the script will stop.

## Some explanations

### `openssl x509`

* This command will handle certificates, e.g. convert them or displays information coded into the certificate.
* It has options for the handling of it's input:
  * `-in <filename>` set the filename from which to fetch the certificate.<br>
    If ommitted it will use stdin.
  * `-inform PEM` (default if ommitted) expects the certificate in PEM format.
  * `-inform DER` expects the certificate in DER format.
* Options for the handling of it's output are:
  * `-out <filename>` set the filename where to write the certificate to.<br>
    If ommitted it will use stout.
  * `-outform PEM` (default if ommitted) writes the in PEM format.
  * `-outform DER` writes the certificate in DER format.

