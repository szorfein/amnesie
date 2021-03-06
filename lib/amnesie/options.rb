require 'optparse'

module Amnesie
  class Options
    attr_reader :init, :mac, :net_dev, :persist, :hostname, :card_match

    def initialize(argv)
      @default = Config.new.load
      @mac = @default[:mac]
      @hostname = @default[:hostname]
      @card_match = @default[:card_match]
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|

        opts.on("-i", "--init", "When used with a init process (systemd, etc...)") do
          @init = true
        end

        opts.on("-m", "--mac", "Forge a random MAC address.") do
          @mac = true
        end

        opts.on("-n", "--net-card NAME", "Card to use, default use card_match from the config file.") do |net|
          @net_dev = net
        end

        opts.on("-p", "--persist", "Enable systemd service") do |net|
          @persist = true
        end

        opts.on("-H", "--hostname", "Generate a new random hostname") do |host|
          @hostname = true
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
