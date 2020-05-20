Gem::Specification.new do |s|
  s.name = "amnesie"
  s.version = "0.0.6"
  s.summary = "A tool to make your computer amnesic"
  s.description = <<-EOF 
    A tool to make your computer amnesic"
  EOF
  s.metadata = {
    "changelog_uri" => "https://github.com/szorfein/amnesie/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/szorfein/amnesie/issues",
    "wiki_uri" => "https://github.com/szorfein/amnesie"
  }
  s.author = ['szorfein']

  s.licenses = ['MIT']
  s.email = 'szorfein@protonmail.com'
  s.homepage = 'https://github.com/szorfein/amnesie'

  s.files = `git ls-files`.split(" ")
  s.files.reject! { |fn| fn.include? "certs" }
  s.files.reject! { |fn| fn.include? "Makefile" }
  s.executables = [ 'amnesie' ]

  s.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE"]

  s.test_files = Dir["test/test_*.rb"]
  s.cert_chain = ['certs/szorfein.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  s.required_ruby_version = '>=2.4'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'

  s.add_runtime_dependency('rainbow', '3.0.0')
  s.add_runtime_dependency('interfacez', '1.0.3')
  s.add_runtime_dependency('nomansland', '0.0.2')
  s.add_runtime_dependency('tty-which', '0.4.2')
end
