require_relative 'amnesie/options'
require_relative 'amnesie/persist'
require_relative 'amnesie/process'
require_relative 'amnesie/network'
require_relative 'amnesie/mac'
require_relative 'amnesie/helpers'

module Amnesie
  def self.random_mac(network)
    mac = Amnesie::MAC.new(network)
    mac.save_origin
    mac.rand
    mac.apply
    puts "New MAC: " + mac.to_s
  end

  def self.services(network)
    persist = Amnesie::Persist.new(network)
    if ! persist.mac_exist?
      puts "Create service..."
      persist.services
    elsif persist.mac_exist?
      persist.update_mac
    end
    persist.menu_mac
    puts persist.to_s
  end

  def self.random_mac_and_kill(network)
    process = Amnesie::Process.new(network)
    process.kill
    random_mac(network)
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
    end
  end
end
