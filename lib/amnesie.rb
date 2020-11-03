require_relative 'amnesie/options'
require_relative 'amnesie/persist'
require_relative 'amnesie/process'
require_relative 'amnesie/network'
require_relative 'amnesie/mac'
require_relative 'amnesie/host'
require_relative 'amnesie/helpers'

module Amnesie
  def self.random_mac(network)
    mac = Amnesie::MAC.new(network)
    mac.set_addr
    puts "New MAC for " + mac.to_s
  end

  def self.services(network)
    # For wifi card
    if TTY::Which.exist?('iwctl')
      Amnesie::Persist::Iwd.new
    elsif TTY::Which.exist?('wpa_supplicant') && network.match(/^wl/)
      Amnesie::Persist::WpaSupplicant.new(network)
    end
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
      puts "menu_mac"
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
      network = options.net_dev ? Network.new(options.net_dev) : Network.new()

      if options.init
        Amnesie.random_mac(network.card)
        exit
      end

      if options.persist
        Amnesie.services(network.card)
      end

      if options.mac
        Amnesie.random_mac_and_kill(network.card)
      end

      if options.hostname
        Amnesie::Host.new
      end
    end
  end
end
