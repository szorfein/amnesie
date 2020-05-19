# https://github.com/seattlerb/minitest#running-your-tests-
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/test_*.rb"]
end

namespace :gem do
  desc "build the gem"
  task :build do
    Dir["amnesie*.gem"].each {|f| File.unlink(f) }
    system("gem build amnesie.gemspec")
    system("gem install amnesie-0.0.5.gem -P MediumSecurity")
  end
end

task :default => :test
