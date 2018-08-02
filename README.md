## Chef Repo

### Production

* Re-provision

``` sh
bundle exec knife solo cook vagrant@192.168.1.6 --node-name wiki11
```

### Development

* Install vagrant https://www.vagrantup.com/downloads.html

* Install virtualbox https://www.virtualbox.org/wiki/Downloads

* Bundle gems `bundle --path vendor`

* Start your VM `vagrant up`

* Install Chef Solo and everything to your VM

``` sh
bundle exec knife solo bootstrap \
  --node-name vagrant \
  --identity-file vagrant.key \
  vagrant@192.168.1.6
```

* In case you just want to cook (provision) without setting up chef on your VM

``` sh
bundle exec knife solo cook \
  --node-name vagrant \
  --identity-file vagrant.key \
  vagrant@192.168.1.6
```

### GeoIP module Enigma
Download the file to `local`

* `curl -O http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz`
* `curl -O http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz`
calculate the `SHA-256`

* `shasum -a 256 GeoIP.dat.gz`
* `shasum -a 256 GeoLiteCity.dat.gz `

update the value in `override_attributes.rb` for `server_enigma`
