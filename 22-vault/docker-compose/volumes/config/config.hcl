storage "file" {
  path = "/vault/file"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/vault/ssl/vault.play.lan.crt"
  tls_key_file = "/vault/ssl/vault.play.lan.key"
}
ui = "true"
api_addr = "http://0.0.0.0:8200"
disable_mlock = "true"