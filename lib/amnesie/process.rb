require 'tty-which'
require_relative 'helpers'

module Amnesie
  class Process
    def initialize(card)
      @systemctl = Helpers::Exec.new("systemctl")
      @pkill = Helpers::Exec.new("pkill")
      @rm = Helpers::Exec.new("rm")
      @card = card
    end

    def kill
      kill_dhcpcd
      kill_dhclient
    end

    def restart
      restart_dhcpcd
      restart_dhclient
      restart_tor
    end

    private

    def kill_dhcpcd
      return if not TTY::Which.exist?('dhcpcd')
      `pgrep -x dhcpcd`
      @pkill.run("dhcpcd") if $?.success?
      puts "Killed dhcpcd"
    end

    def kill_dhclient
      return if not TTY::Which.exist?('dhclient', paths: ['/sbin'])
      `pgrep -x dhclient`
      @pkill.run("dhclient") if $?.success?
      @rm.run("/run/dhclient.#{@card}.pid") if File.exist? "/run/dhclient.#{@card}.pid"
      @rm.run("/var/lib/dhcp/dhclient.#{@card}.leases") if File.exist? "/var/lib/dhcp/dhclient.#{@card}.leases"
      puts "Killed dhclient"
    end

    def restart_dhcpcd
      return if not TTY::Which.exist?('dhcpcd')
      if TTY::Which.exist?('systemctl') 
        @systemctl.run("restart dhcpcd")
      else
        dhcpcd = Helpers::Exec.new("dhcpcd")
        dhcpcd.run("-q")
      end
      puts "Restarted dhcpcd"
    end

    def restart_dhclient
      return if not TTY::Which.exist?('dhclient', paths: ['/sbin'])
      dhclient = Helpers::Exec.new("dhclient")
      # command tested on debian, not try on another system yet...
      dhclient.run("-4 -v -i -pf /run/dhclient.#{@card}.pid -lf /var/lib/dhcp/dhclient.#{@card}.leases -I -df /var/lib/dhcp/dhclient6.#{@card}.leases #{@card}")
      if TTY::Which.exist?('systemctl')
        `systemctl is-active ifup@#{@card}`
        @systemctl.run("restart ifup@#{@card}") if $?.success?
      end
      puts "Restarted dhclient"
    end

    def restart_tor
      return if not TTY::Which.exist?('tor')
      if TTY::Which.exist?('systemctl') 
        `systemctl is-active tor`
        @systemctl.run("restart tor") if $?.success?
        puts "Restarted tor"
      end
    end
  end
end
