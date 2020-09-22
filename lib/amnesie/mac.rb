require 'securerandom'

module Amnesie
  class MAC
    def initialize(card)
      @card = card
      @ip = Helpers::Exec.new("ip")
      save_origin
      new_mac
    end

    def set_addr
      @ip.run("link set dev #{@card} address #{@mac}")
    end

    def down
      @ip.run("link set dev #{@card} down")
    end

    def up
      @ip.run("link set dev #{@card} up")
    end

    def to_s
      @card + " " + @mac
    end

    private

    def new_mac
      first = SecureRandom.hex(1)
      last = SecureRandom.hex(5)
      lastfive = last.split(//).each_slice(2).to_a.map(&:join).join(':')
      firstbyte = `printf '%02X' $(( 0x#{first} & 254 | 2))`
      @mac = "#{firstbyte}:#{lastfive}".downcase
    end

    def search_curr_mac
      @curr = `ip addr show dev #{@card} | grep -i ether | awk '{print $2}'`.chomp
    end
    
    def save_origin
      return if File.exist? "/tmp/mac_#{@card}"
      search_curr_mac
      filename="/tmp/mac_#{@card}"
      File.write(filename, @curr)
      puts "Origin saved"
    end
  end
end
