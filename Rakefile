# https://github.com/seattlerb/minitest#running-your-tests-
require "rake/testtask"
require File.dirname(__FILE__) + "/lib/amnesie/version"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/test_*.rb"]
end

# rake gem:build
namespace :gem do
  desc "build the gem"
  task :build do
    Dir["amnesie*.gem"].each {|f| File.unlink(f) }
    system("gem build amnesie.gemspec")
    system("gem install amnesie-#{Amnesie::VERSION}.gem -P MediumSecurity")
  end
end

task :default => :test
