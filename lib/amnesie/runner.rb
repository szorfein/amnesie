require_relative 'options'

module Amnesie
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
    end
    def run
    end
  end
end
