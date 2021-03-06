require_relative 'amnesie/options'
require_relative 'amnesie/persist'
require_relative 'amnesie/process'
require_relative 'amnesie/network'
require_relative 'amnesie/mac'
require_relative 'amnesie/host'
require_relative 'amnesie/config'
require_relative 'amnesie/helpers'

module Amnesie

  OPTIONS = {
    mac: true,
    hostname: false,
    card_match: /^en/
  }.freeze

  def self.random_mac(network)
    mac = Amnesie::MAC.new(network)
    mac.set_addr
    puts "New MAC for " + mac.to_s
  end

  # For wifi card, no need systemd
  def self.persist_wifi
    if TTY::Which.exist?('iwctl')
      Amnesie::Persist::Iwd.new
    elsif TTY::Which.exist?('wpa_supplicant')
      Amnesie::Persist::WpaSupplicant.new
    end
  end

  def self.services(network)
    # For ethernet card
    if TTY::Which.exist?('systemctl') && network.match(/^en/)
      persist = Amnesie::Persist::Systemd.new(network)
      if ! persist.mac_exist?
        puts "Create service..."
        persist.services
      elsif persist.mac_exist?
        puts "service exist"
        persist.update_mac
      end
      persist.menu_mac
    end
  end

  def self.random_mac_and_kill(network)
    process = Amnesie::Process.new(network)
    mac = Amnesie::MAC.new(network)

    process.kill
    mac.down
    mac.set_addr
    puts "New MAC for " + mac.to_s
    mac.up
    process.restart

  end

  class Main
    def initialize(argv)
      @argv = argv
      run
    end

    private

    def run
      options = Options.new(@argv)
      networks = Network.new(options.card_match, options.net_dev).search
      puts "cards #{networks}"

      if options.init
        networks.each { |net|
          Amnesie.random_mac(net)
        }
      end

      if options.persist
        networks.each { |net|
          Amnesie.services(net)
        }
        Amnesie.persist_wifi
        exit
      end

      if options.mac
        networks.each { |net|
          Amnesie.random_mac_and_kill(net)
        }
      end

      if options.hostname
        Amnesie::Host.new
      end
    end
  end
end
