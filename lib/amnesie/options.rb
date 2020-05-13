require 'optparse'

module Amnesie
  class Options

    def initialize(argv)
      parse(argv)
    end

    def parse(argv)
      OptionParser.new do |opts|

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
