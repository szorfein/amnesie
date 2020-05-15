require 'tty-which'
require_relative 'helpers'

module Amnesie
  class Process
    def initialize
      @procs = [ "dhcpcd", "tor" ]
      @systemctl = Helpers::Exec.new("systemctl")
      @pkill = Helpers::Exec.new("pkill")
    end

    def kill
      return if not TTY::Which.exist?('dhcpcd')
      @pkill.run("dhcpcd")
      puts "Killed dhcpcd"
    end

    def restart
      return if not TTY::Which.exist?('systemctl')
      @procs.each do |p|
        if TTY::Which.exist?(p)
          @systemctl.run("restart #{p}")
          puts "Restarted #{p}"
        end
      end
    end
  end
end
