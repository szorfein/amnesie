module Amnesie
  module Persist
    class Systemd
      def initialize(card = nil)
        @card = card
        @systemd_dir = search_systemd_dir
        @systemctl = Helpers::Exec.new("systemctl")
      end

      def mac_exist?
        File.exist? "#{@systemd_dir}/amnesie-mac@.service"
      end

      def to_s
        @systemd_dir
      end

      def services
        mac_service
        new_service = Helpers::NewSystemd.new(@string, "amnesie-mac@.service")
        new_service.add
        new_service.perm("root", "644")
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
        print "Action on amnesie-mac@.service for #{@card} (enable/disable) ? (e/d) "
        answer = gets.chomp
        case answer
        when /^e|^E/
          mac_enable
        when /^d|^D/
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
        if Dir.exist? "/usr/lib/systemd/system"
          "/usr/lib/systemd/system"
        elsif Dir.exist? "/lib/systemd/system"
          "/lib/systemd/system"
        else
          raise "No directory systemd found"
          exit
        end
      end

      def mac_service
        dhcp=''
        if TTY::Which.exist?('dhcpcd')
          dhcp='dhcpcd.service'
        end
        @string=<<EOF
[Unit]
Description=Spoof MAC Address on %I
Wants=network-pre.target
Before=network-pre.target #{dhcp}
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
ExecStart=/usr/bin/env bash -lc "amnesie -i -n %I"
ExecReload=/usr/bin/env bash -lc "amnesie -m -n %I"
TimeoutSec=30

[Install]
WantedBy=multi-user.target
EOF
      end
    end
  end
end
