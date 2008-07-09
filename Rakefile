require 'rubygems'
require 'echoe'

$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
require 'multi_conditions'


# Common package properties
PKG_NAME    = ENV['PKG_NAME'] || ActiveRecord::Base::MultiConditions::GEM
PKG_VERSION = ENV['PKG_VERSION'] || ActiveRecord::Base::MultiConditions::VERSION
PKG_SUMMARY = "An ActiveRecord plugin for dealing with complex search :conditions."
PKG_FILES   = FileList.new("{lib,test}/**/*.rb") do |fl|
  fl.exclude 'TODO'
  fl.include %w(README.rdoc README CHANGELOG MIT-LICENSE)
  fl.include %w(Rakefile setup.rb)
end
RUBYFORGE_PROJECT = 'activerecord-multiconditions'


# Prepare version number, don't forget about snapshots!
version = PKG_VERSION
if ENV['SNAPSHOT'].to_i == 1
  version << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


Echoe.new(PKG_NAME, version) do |p|
  p.author = "Simone Carletti"
  p.email = "weppos@weppos.net"
  p.summary     = PKG_SUMMARY
  p.description = <<-EOF
    MultiConditions is a simple ActiveRecord plugin \
    for storing ActiveRecord query conditions and make complex queries painless.
    EOF
  p.url = "http://code.simonecarletti.com/activerecord-multiconditions"
  
  p.version = PKG_VERSION
  p.changes = ''
  
  p.dependencies = ['activerecord >=2.0.0']
  p.rcov_options = ["-xRakefile"]
  
  p.need_zip = true
  p.include_rakefile = true
  
  p.project = RUBYFORGE_PROJECT
  
  p.rdoc_pattern = /^(lib|CHANGELOG|MIT\-LICENSE|README)/
end


begin 
  require 'code_statistics'
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["MultiConditions", "lib"], 
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end
