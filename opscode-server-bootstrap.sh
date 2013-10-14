knife bootstrap ip_address \
  --ssh-user root \
  --ssh-password password \
  --ssh-port 22 \
  --run-list "role[shop_on_rails]" \
  --sudo \
  -d ubuntu12.04-gems-rvm
