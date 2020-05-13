require_relative 'options'
require_relative 'mac'
require_relative 'process'
require_relative 'network'

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
        process = Amnesie::Process.new
        card = Amnesie::MAC.new(@network.card)

        process.kill
        card.save_origin
        card.rand
        card.apply
        puts card.to_s
        process.restart
      end
    end
  end
end
