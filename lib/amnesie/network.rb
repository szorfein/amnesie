require 'interfacez'

module Amnesie
  class Network
    def initialize(card_match, name = nil)
      @card_match = card_match
      @name = name
      @devs = []
      @check = false
    end

    def search
      if @name
        verify_card
        @devs << @name
      else
        search_cards
        @devs
      end
    end

    private

    def verify_card
      Interfacez.all do |interface|
        if interface == @name then
          @check = true
        end
      end
      if !@check then
        raise ArgumentError, "Interface no found" if !@check
      end
    end

    def search_cards
      Interfacez.all do |interface|
        @devs << interface if interface.match(@card_match)
      end
    end
  end
end
