require 'securerandom'

module Amnesie
  class Host
    def initialize
      @nb = rand(8..25)
      @hostname = SecureRandom.alphanumeric(@ng)
      Nito::Hostname.new(@hostname)
      puts to_s
    end

    def to_s
      "Your hostname will become #{@hostname}"
    end
  end
end
