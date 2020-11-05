require 'nito'
require 'tempfile'

module Amnesie
  module Persist
    class WpaSupplicant
      def initialize
        @cards = Network.new(/wl^/, nil).search
        @tmp = Tempfile.new("main.conf")
        apply_cards
      end

      def apply_cards
        @cards.each { |card|
          apply(card)
        }
      end

      private

      def apply(card)
        file = "/etc/wpa_supplicant/wpa_supplicant-#{card}.conf"
        if ! File.exist? file ||
            ! grep?(file, /gas_rand_mac/)
          puts "Add #{file}"
          Nito::Cat.new(file, wpa_conf)
        else
          puts "MAC random on wpa_supplicant seem enable."
        end
      end

      def wpa_conf
        <<EOF
mac_addr=1
preassoc_mac_addr=1
gas_rand_mac_addr=1
EOF
      end
    end
  end
end
