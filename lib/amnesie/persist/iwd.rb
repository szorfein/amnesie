require 'nito'
require 'tempfile'

module Amnesie
  module Persist
    class Iwd
      def initialize
        @tmp = Tempfile.new("main.conf")
        apply
      end

      def apply
        File.write(@tmp, iwd_conf)
        if ! File.exist? "/etc/iwd/main.conf" ||
            ! grep?("/etc/iwd/main.conf", /AddressRandomization/)
          puts "Add iwd/main.conf"
          Nito::Cp.new(@tmp.path, "/etc/iwd/main.conf")
        else
          puts "MAC random on iwd seem enable."
        end
      end

      private

      def iwd_conf
        <<EOF
[General]
AddressRandomization=network
AddressRandomizationRange=full
EOF
      end
    end
  end
end
