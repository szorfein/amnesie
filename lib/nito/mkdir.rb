require 'fileutils'

module Nito
  class Mkdir
    def initialize(dir)
      @dir = dir
      mkdir
    end

    private
    def mkdir
      begin
        FileUtils.mkdir_p @dir if ! Dir.exist? @dir
      rescue Errno::EACCES
        FileUtils.mkdir_p @dir if ! Dir.exist? @dir
      end
    end
  end
end
