require 'fileutils'

module Nito
  class Cp
    @@pass = nil

    def initialize(src, dst, perm = 0644)
      @src = src
      @dst = dst
      @perm = perm
      if ID == "0"
        root
      else
        @@pass = Pass.new if ! @@pass
        sudo
      end
    end

    private

    def root
      FileUtils.copy_file(@src, @dst)
      FileUtils.chmod(@perm.to_s, @dst)
    end

    def sudo
      Sudo.run("cp #{@src} #{@dst}", @@pass.secret)
      perm = sprintf "%o", @perm
      #puts "Applying perm #{perm}"
      Sudo.run("chmod #{perm} #{@dst}", @@pass.secret)
    end
  end
end
