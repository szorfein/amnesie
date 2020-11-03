require 'fileutils'
require_relative 'nito/pass'
require_relative 'nito/cat'
require_relative 'nito/sed'
require_relative 'nito/hostname'

module Nito
  ID = `id -u`.chomp.freeze
  PASS = ID != 0 ? Nito::Pass.new : nil
  PASS.freeze

  module Sudo
    def self.run(command, input = nil)
      IO.popen("sudo -S #{command}", 'r+') do |io|
        begin
          io.puts input
          io.close_write
          io.read
        rescue Interrupt
          puts "\nInterrupt"
        end
      end
    end
  end

  class Cp
    def initialize(src, dst, perm = 0644)
      @src = src
      @dst = dst
      @perm = perm
      if ID == "0"
        root
      else
        sudo
      end
    end

    private

    def root
      FileUtils.copy_file(@src, @dst)
      FileUtils.chmod(@perm.to_s, @dst)
    end

    def sudo
      Sudo.run("cp #{@src} #{@dst}", PASS.secret)
      perm = sprintf "%o", @perm
      puts "Applying perm #{perm}"
      Sudo.run("chmod #{perm} #{@dst}", PASS.secret)
    end
  end
end
