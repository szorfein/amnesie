module Nito
  module Sudo
    def self.run(command, input = nil)
      #IO.popen("sudo -S #{command}", 'r+') do |io|
      IO.popen("sudo #{command}", 'r+') do |io|
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
end
