require 'highline/import'

module Nito
  class Pass 
    attr_reader :secret
    def initialize
      get
    end
    private
    def get(prompt = 'Password: ')
      @secret = ask(prompt) { |q| q.echo = false }
    end
  end
end
