# getWebserverNames.sh

## Porpose

This bash script connect to a SSL/TLS server and display information about the presented certificate.<br>
Information that are shown:

* The issuer of the certificate.
* The date up to which the certificate is valid.
* The subject of the certificate.
* It's subject alternate names (SAN).
* The certificate chain presented by the server.

## Example

```bash
~$ openSSLscripts/getWebserverNames.sh github.com
Issuer:  C=US
         O=DigiCert
         Inc.
         CN=DigiCert High Assurance TLS Hybrid ECC SHA256 2020 CA1
Up to:   Mar 30 23:59:59 2022 GMT
Subject: C=US
         ST=California
         L=San Francisco
         O=GitHub
         Inc.
         CN=github.com
SAN:     DNS:github.com
         DNS:www.github.com
presented certificate chain:
         0 s: CN=github.com
         1 s: CN=DigiCert High Assurance TLS Hybrid ECC SHA256 2020 CA1
```

## Some explanations

### `openssl s_client`

* Connects to a SSL/TLS server (like "`telnet server port`", but SSL/TLS encrypted)<br>
  and - as a side effect - gives several information of the active SSL/TLS-session including the certificate(s).
* in script: `openssl s_client $EXTRAOPTS -showcerts -connect $SERVERADDRESS:$SERVERPORT`
  * `-showcerts` adds the full certificate chain to the output, otherwise only the server's certificate is shown.
  * `-starttls smtp` uses a SMTP dialog to connect in cleartext and then sends `STARTTLS` to switch to SSL/TLS and finaly will get the certificate
* Examples:
  * `openssl s_client -connect www.example.com:443`
  * `openssl s_client -showcerts -starttls smtp -connect mail.example.com:25`

### `openssl x509`

* Displays or manipulates certificate information provided either on stdin or from file, if `-in filename` is specified.
* By default it expects PEM encoded certificates (= everyting between `-----BEGIN CERTIFICATE-----`<br>
  and `-----END CERTIFICATE-----`).
* It usually handles only the first certificate, if multiple are presented.
* in script: `openssl x509 -noout -text`
  * `-noout` supresses the certificate output in "binary" format (by default PEM).
  * `-text` prints the certificate's information in plain text.

### `sed`

* The `sed` commands on Linux and MacOS are different (= have different options / syntax), so we have to test which one is running.<br>
  `if sed --version 2>/dev/null | head -1 | grep -q GNU`
* On MacOS the syntax looks a bit complex to replace all comma+space combinations (`, `) with new lines and an identation:
  ```bash
  sed $'s/,/\\\n        /g'
  ```
  The `$'...'` expands the escape sequences in the quote:
  * `\\` converts to a real `\`.
  * `\n` converts to a newline.
  * `\<newline>` is send to sed.
  * it needs to be ecaped for sed, so sed won't end, but show the newline-

