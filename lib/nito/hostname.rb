require 'tempfile'

module Nito
  class Hostname
    def initialize(hostname)
      @hostname = hostname
      @hostname_file = '/etc/hostname'
      @hosts_file = '/etc/hosts'
      new
    end

    private

    def new
      tmp = Tempfile.new('hostname')
      File.write(tmp, @hostname)
      Nito::Cp.new(tmp.path, @hostname_file)
      reg_1 = /^127.0.0.1[\s]+localhost/
      reg_2 = /^::1[\s]+localhost/
      Nito::Sed.new(@hosts_file, reg_1, "127.0.0.1 localhost #{@hostname}")
      Nito::Sed.new(@hosts_file, reg_2, "::1 localhost #{@hostname}")
    end
  end
end
