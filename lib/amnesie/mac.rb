require_relative 'helpers'

module Amnesie
  class MAC
    def initialize(card)
      @card = card
      @ip = Helpers::Exec.new("ip")
    end

    # TODO yep...
    def rand
      first=`printf ""; dd bs=1 count=1 if=/dev/urandom 2>/dev/null | hexdump -v -e '/1 "%02X"'`
      last=`printf ""; dd bs=1 count=5 if=/dev/urandom 2>/dev/null | hexdump -v -e '/1 ":%02X"'`
      mac="#{first}#{last}"
      lastfive=`echo #{mac} | cut -d: -f 2-6`.chomp
      firstbyte=`echo #{mac} | cut -d: -f 1`.chomp
      firstbyte=`printf '%02X' $(( 0x#{firstbyte} & 254 | 2))`
      @mac="#{firstbyte}:#{lastfive}"
    end

    def to_s
      rand
      @card + " " + @mac
    end

    def search_curr_mac
      @curr = `ip addr show dev #{@card} | grep -i ether | awk '{print $2}'`
    end

    def save_origin
      search_curr_mac
      txt="/tmp/mac_#{@card}"
      if not File.exist?(txt)
        file = File.open(txt, 'a+')
        file.puts(@curr)
        file.close
        puts "Origin saved"
      end
    end

    def apply
      @ip.run("link set dev #{@card} down")
      @ip.run("link set dev #{@card} address #{@mac}")
      @ip.run("link set dev #{@card} up")
    end
  end
end
