require 'securerandom'

module Amnesie
  class Host
    def initialize
      @hostname = SecureRandom.alphanumeric(10)
      Nito::Hostname.new(@hostname)
      puts to_s
    end

    def to_s
      "Your hostname will become #{@hostname}"
    end
  end
end
