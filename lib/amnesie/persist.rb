require 'fileutils'
require 'tempfile'
require 'tty-which'
require_relative 'helpers'

module Amnesie
  class Persist

    def initialize(card)
      @card = card
      @systemd_dir = search_systemd_dir
      @mv = Helpers::Exec.new("mv")
      @systemctl = Helpers::Exec.new("systemctl")
    end

    def mac_exist?
      File.exist? "#{@systemd_dir}/amnesie-mac@.service"
    end

    def to_s
      @systemd_dir
    end

    def mac_service
      dhcp=''
      if TTY::Which.exist?('dhcpcd')
        dhcp='dhcpcd.service'
      end
      @string=<<EOF
[Unit]
Description=MAC Change %I
Wants=network-pre.target
Before=network-pre.target #{dhcp}
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
ExecStart=/usr/bin/env bash -lc "amnesie -i -m -n %I"
TimeoutSec=30

[Install]
WantedBy=multi-user.target
EOF
    end

    def services
      tmp = Tempfile.new("amnesie-mac@.service")
      mac_service
      File.open(tmp.path, 'w') do |file|
        file.puts @string
      end
      dest=@systemd_dir + "/amnesie-mac@.service"
      @mv.run("#{tmp.path} #{dest}")
      @systemctl.run("daemon-reload")
    end

    def update_mac
      print "Found a old amnesie-mac@.service, update? (y|n) "
      answer = gets.chomp
      case answer
      when /^y|^Y/
        services
      end
    end

    def menu_mac
      print "amnesie-mac@.service for #{@card}? (enable,disable) "
      answer = gets.chomp
      case answer
      when /^enable/
        mac_enable
      when /^disable/
        mac_disable
      end
    end

    private

    def mac_enable
      @systemctl.run("enable amnesie-mac@#{@card}.service")
    end

    def mac_disable
      @systemctl.run("disable amnesie-mac@#{@card}.service")
    end

    def search_systemd_dir
      if Dir.exist? "/lib/systemd/system"
        "/lib/systemd/system"
      elsif Dir.exist? "/usr/lib/systemd/system"
        "/usr/lib/systemd/system"
      else
        raise "No directory systemd found"
        exit
      end
    end
  end
end
