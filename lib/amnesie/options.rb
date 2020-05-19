require 'optparse'

module Amnesie
  class Options
    attr_reader :mac, :netcard, :persist

    def initialize(argv)
      parse(argv)
    end

    def parse(argv)
      OptionParser.new do |opts|

        opts.on("-m", "--mac", "What is my MAC address?") do
          @mac = true
        end

        opts.on("-n", "--net-card NAME", "The name of the card to use") do |net|
          @netcard = net
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
