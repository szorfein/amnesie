# amnesie
A tool to make your computer amnesic.

Inspiration come from a post found on [Qubes-OS](https://www.qubes-os.org/doc/anonymizing-your-mac-address/) and the [Whonix](https://www.whonix.org/) project. 
+ Anonymizing your MAC Address
+ Randomize all Ethernet and Wifi connections
+ Randomize your hostname
+ [Boot Clock Randomization](https://www.whonix.org/wiki/Boot_Clock_Randomization)

## Install
Amnesie is cryptographically signed, so add my public key (if you haven’t already) as a trusted certificate.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/szorfein/amnesie/master/certs/szorfein.pem)

And install the gem

    $ gem install amnesie -P MediumSecurity

To be able to use the `persist mode` (with systemd for now), the gem should be installed system-wide:  
+ For gentoo, a package is available on my repo [ninjatools](https://github.com/szorfein/ninjatools/tree/master/dev-ruby/amnesie).  
+ Arch seem to use [Quarry](https://wiki.archlinux.org/index.php/Ruby#Quarry).  
+ On distro based on debian, gem are installed system-wide.  

If you can, i recommend that you create a package for your distribution.  

## Usage
To change the MAC address for eth0:

    $ amnesie -n eth0 -m

Create or Disable all systemd services for a network card:

    $ amnesie -p -n wlp2s0

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/amnesie/issues/new).

### links
+ https://rubyreferences.github.io/rubyref
+ https://rubystyle.guide/
