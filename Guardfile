guard :rspec, cmd: "chef exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  #Recipe files
  watch(%r{^(recipes)/(.+)\.rb$}) { rspec.spec_dir }
  watch(%r{^(resources)/(.+)\.rb$}) { rspec.spec_dir }
  watch(%r{^(libraries)/(.+)\.rb$}) { rspec.spec_dir }

end
