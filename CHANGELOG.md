## 0.0.5, release 2020-05-19
* Create a amnesie-mac@.service (work only if the gem is install system-wide)
* Add -p|--persist
* Replace Makefile by a Rakefile

## 0.0.4, release 2020-05-16
* Debian10 need to reload ifup@card-name too
* Correct path where search dhclient (/bin,/sbin)
* Enhance stuff for kill and reload dhclient (tested on debian 10)

## 0.0.3, release 2020-05-15
* Add stuff for kill and reload dhclient (tested on debian 10)

## 0.0.2, release 2020-05-15
* Rakefile, add rake as dev dependencie
* Check if process/program exist before kill/restart

## 0.0.1, release 2020-05-13
* Can randomize a mac address
* Restart services (tor|dhcpcd)
* Kill dhcpcd
* Add -h|--help
* Base project
