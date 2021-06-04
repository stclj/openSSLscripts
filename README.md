# openSSLscripts

## Purpose

Litte (bash) scripts that use openSSL to
* gather informations about certificates provided by SSL/TLS servers
* convert SSL certificates

## Repository structure

`README.md`       | This document
`openSSLscripts/` | directory containing the actual scripts
`docs/`           | directory containing the documentation to the scripts

## Scripts

* [`getWebserverNames.sh`](docs/getWebserverNames.md) - connect to SSL/TLS server and display information about presented certificate
* [`convertDERtoPEM.md`](docs/convertDERtoPEM.md) - converts SSL certificates from DER-format into PEM-format
* [`convertPEMtoDER.md`](docs/convertPEMtoDER.md) - converts SSL certificates from PEM-format into DER-format

## Author

* Steffen Clausjuergens
* GitHub [stclj](https://github.com/stclj)
* Twitter [@stclj](https://twitter.com/stclj)

