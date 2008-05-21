# 
# = ActiveRecord::MultiConditions
#
# An ActiveRecord plugin for dealing with complex search :conditions.
# 
#
# Category::   ActiveRecord
# Package::    ActiveRecord::MultiConditions
# Author::     Simone Carletti <weppos@weppos.net>
#
#--
# SVN: $Id$
#++


# prepend lib folder
$:.unshift(File.dirname(__FILE__) + '/../lib')

# load active_record
require 'rubygems'
begin
  gem 'activerecord', '>= 2.0'
rescue Gem::LoadError => e
  abort e.message
end

require 'active_record'
require 'test/unit'
require 'multi_conditions'

require File.dirname(__FILE__) + '/helper_database'
