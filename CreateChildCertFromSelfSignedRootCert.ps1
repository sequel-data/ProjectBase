New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert  -KeySpec Signature `
-Subject "CN=HookBang-MMP2SChildCert" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert1 -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")