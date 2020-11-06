require 'yaml'

module Amnesie
  class Config
    def initialize
      @file = File.join(find_conf)
      #puts "Config file in #{@file}"
    end

    def load
      if !File.exist? @file
        puts "[+] Config file created at #{@file}"
        save
      end
      YAML.load_file @file
    end

    private

    def find_conf
      if !ENV["HOME"] || ENV["HOME"] == '/root'
        "/etc/conf.d/amnesie.yaml"
      else
        "#{ENV['HOME']}/.config/amnesie/amnesie.yaml"
      end
    end

    def save
      dir = File.dirname @file
      Nito::Mkdir.new(dir)
      File.open(@file, 'w') { |f| YAML::dump(OPTIONS, f) }
    end
  end
end
