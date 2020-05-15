# https://github.com/seattlerb/minitest#running-your-tests-
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/test_*.rb"]
end

task :default => :test
