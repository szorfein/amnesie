require_relative 'helpers'

module Amnesie
  class Process
    def initialize
      @procs = [ "dhcpcd", "tor" ]
      @systemctl = Helpers::Exec.new("systemctl")
      @pkill = Helpers::Exec.new("pkill")
    end

    def kill
      @pkill.run("dhcpcd")
      puts "Killed dhcpcd"
    end

    def restart
      @procs.each do |p|
        @systemctl.run("restart #{p}")
        puts "Restarted #{p}"
      end
    end
  end
end
