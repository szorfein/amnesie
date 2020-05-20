require_relative 'options'
require_relative 'mac'
require_relative 'process'
require_relative 'network'
require_relative 'persist'

module Amnesie
  class Runner
    
    def initialize(argv)
      @options = Options.new(argv)
      @network = false
    end

    def run
      if @options.mac then
        if not @network
          @network = Amnesie::Network.new(@options.netcard)
        end
        puts @network.card
        process = Amnesie::Process.new(@network.card)
        card = Amnesie::MAC.new(@network.card)

        process.kill unless @options.init
        card.save_origin
        card.rand
        card.apply
        puts card.to_s
        process.restart unless @options.init
      end
      if @options.persist then
        if not @network
          @network = Amnesie::Network.new(@options.netcard)
        end
        puts @network.card
        persist = Amnesie::Persist.new(@network.card)
        if ! persist.mac_exist?
          puts "Create service..."
          persist.services
        elsif persist.mac_exist?
          persist.update_mac
        end
        persist.menu_mac
        puts persist.to_s
      end
    end
  end
end
