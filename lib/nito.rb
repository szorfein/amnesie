require_relative 'nito/pass'
require_relative 'nito/sudo'
require_relative 'nito/cp'
require_relative 'nito/cat'
require_relative 'nito/sed'
require_relative 'nito/hostname'
require_relative 'nito/mkdir'

module Nito
  ID = `id -u`.chomp.freeze
end
