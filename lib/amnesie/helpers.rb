require 'fileutils'
require 'tempfile'

module Helpers
  class Exec
    def initialize(name)
      @search_uid = Process::Sys.getuid
      @name = name
    end

    def run(args)
      if @search_uid == 0 then
        #puts "found root - uid #{@search_uid}"
        system(@name + " " + args)
      else
        #puts "sudo #{@name} #{args}"
        system("sudo " + @name + " " + args)
      end
    end
  end

  class NewFile
    def initialize(string, name, dest = "/tmp")
      @string = string
      @name = name
      @dest = dest + "/" + @name
    end
    
    def add
      @mv = Helpers::Exec.new("mv")
      tmp = Tempfile.new(@name)
      File.open(tmp.path, 'w') do |file|
        file.puts @string
      end
      @mv.run("#{tmp.path} #{@dest}")
    end

    def perm(user, perm)
      chown = Helpers::Exec.new("chown")
      chmod = Helpers::Exec.new("chmod")
      chown.run("#{user}:#{user} #{@dest}")
      chmod.run("#{perm} #{@dest}")
    end
  end

  class NewSystemd < NewFile
    def initialize(string, name)
      super
      @systemd_dir = search_systemd_dir
      @dest = @systemd_dir + "/" + @name
    end

    def add
      @systemctl = Helpers::Exec.new("systemctl")
      super
      @systemctl.run("daemon-reload")
    end

    private
    def search_systemd_dir
      if Dir.exist? "/lib/systemd/system"
        "/lib/systemd/system"
      elsif Dir.exist? "/usr/lib/systemd/system"
        "/usr/lib/systemd/system"
      else
        raise "Systemd is no found..."
      end
    end
  end
end
