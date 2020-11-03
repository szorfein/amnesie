require 'tempfile'

module Nito
  class Sed
    def initialize(file, regex, change)
      @file = file
      @regex = regex
      @change = change
      apply
    end

    def apply
      raise ArgumentError "No file #{@file} exist" if ! File.exist? @file
      tmp = Tempfile.new('sed')
      File.open(@file).each { |l|
        if l.match(@regex)
          File.write(tmp, "#{@change}\n", mode: 'a')
        else
          File.write(tmp, l, mode: 'a')
        end
      }
      Nito::Cp.new(tmp.path, @file)
    end
  end
end
