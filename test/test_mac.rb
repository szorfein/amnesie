require 'minitest/autorun'
require_relative '../lib/amnesie/mac'

class TestMAC
  describe 'to_s' do
    it 'should return card name nolife with a random MAC' do
      card = 'nolife'
      mac = /#{card} [0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}/

      amn = Amnesie::MAC.new(card).to_s
      _(amn).must_match mac
    end
  end
end
