## 0.0.8, release 2020-09-22
* Enhance code
* Update the class MAC, more ruby like
* Use securerandom (>= ruby2.5)

## 0.0.7, release 2020-05-29
* Shortcut action for service (e/d) 
* Correct permission on amnesie-mac@.service
* Enhance lib/amnesie/helper

## 0.0.6, release 2020-05-20
* Init a doc with RDoc.
* Add -i|--init to start init process properly.
* Add dhcpcd to the mac@.service, dhclient doesn't seem necessary.
* Correct the mac@.service.

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
