Gem::Specification.new do |s|
  s.name = "rails-asset_profile"
  s.version = "0.0.1"
  s.summary = "Profiled asset compilation for Rails"
  s.description = "Shows you stats on how long each asset compiles."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/nadarei/rails-asset_profile"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency "rails", "~> 3.2.0"
end
