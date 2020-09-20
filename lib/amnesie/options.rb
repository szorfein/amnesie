require 'optparse'

module Amnesie
  class Options
    attr_reader :init, :mac, :net_dev, :persist

    def initialize(argv)
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|

        opts.on("-i", "--init", "Used with init process (systemd, etc...)") do
          @init = true
        end

        opts.on("-m", "--mac", "Forge a random MAC address.") do
          @mac = true
        end

        opts.on("-n", "--net-card NAME", "The name of the card to use") do |net|
          @net_dev = net
        end

        opts.on("-p", "--persist", "Enable systemd service") do |net|
          @persist = true
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
