module Nito
  class Cat
    def initialize(conf, string)
      @conf = conf
      @string = string
      write_file
    end

    private
    def write_file
      tmp = Tempfile.new(@conf)
      if File.exist? @conf
        File.open(@conf).each { |l|
          File.write(tmp, l, mode: 'a')
        }
      end
      File.write(tmp, @string, mode: 'a')
      Nito::Cp.new(tmp.path, @conf)
    end
  end
end
