require 'rubygems'
require 'rake'
require 'echoe'

$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
require 'multi_conditions'


# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || MultiConditions::GEM
PKG_VERSION = ENV['PKG_VERSION'] || MultiConditions::VERSION
PKG_SUMMARY = "An ActiveRecord plugin for dealing with complex search :conditions."
PKG_FILES = FileList.new("{lib,test}/**/*.rb") do |fl|
  fl.include %w(README.rdoc CHANGELOG.rdoc LICENSE.rdoc)
  fl.include %w(Rakefile setup.rb)
end
RUBYFORGE_PROJECT = 'activerecord-multiconditions'

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


Echoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author      = "Simone Carletti"
  p.email       = "weppos@weppos.net"
  p.summary     = PKG_SUMMARY
  p.description = <<-EOD
    MultiConditions is a simple ActiveRecord plugin \
    for storing ActiveRecord query conditions and make complex queries painless.
    EOD
  p.url = "http://code.simonecarletti.com/activerecord-multiconditions"
  p.project = RUBYFORGE_PROJECT
  
  p.need_zip      = true
  p.rcov_options  = ["-x Rakefile -x rcov"]
  p.rdoc_pattern  = /^(lib|CHANGELOG.rdoc|README.rdoc)/
  
  p.runtime_dependencies += ['activerecord >=2.0.0']
  
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
