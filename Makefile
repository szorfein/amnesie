build:
	rm -f amnesie*.gem
	gem build amnesie.gemspec
	gem install amnesie-0.0.3.gem -P MediumSecurity
