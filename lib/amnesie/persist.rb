module Amnesie
  module Persist
    def self.grep?(file, regex)
      is_found = false
      return is_found if ! File.exist? file
      File.open(file) do |f|
        f.each do |line|
          is_found = true if line.match(regex)
        end
      end
      is_found
    end
  end
end

require_relative 'persist/iwd'
require_relative 'persist/systemd'
