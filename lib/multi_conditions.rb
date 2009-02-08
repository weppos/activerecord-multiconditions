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


require 'rubygems'
require 'active_record'


#
# = ActiveRecord::MultiConditions
# 
# MultiConditions is a simple ActiveRecord plugin for storing ActiveRecord 
# query and make complex queries painless.
# 
# This plugin doesn't replace ActiveRecord#with_scope method,
# nor the basic :condition usage but extends it with the ability
# of storing illimitate conditions in multiple step.
# 
#   conditions = MultiConditions.new(ModelClass)
#   # ... do some elaboration
#   conditions.append_condition(['active = ? AND query LIKE ?', true, '%foo'])
#   # ... other elaboration
#   conditions.append_condition(['name = ?', 'aname'])
#   
#   conditions.to_conditions
#   # => "active = true AND query LIKE '%foo' AND name = 'aname'"
# 
# == Example Usage
# 
#   class Task < ActiveRecord::base
#     # your model
#   end
#
#   conditions = Task.multiconditions(['name = ?', 'aname']) do |m|
#     m.append_condition(['active = ? AND query LIKE ?', true, '%foo'])
#     m.append_condition(:field => false)
#   end
#   
#   Task.find(:all, :conditions => conditions.to_conditions)
# 
#
module MultiConditions

  module Version #:nodoc:
    MAJOR = 0
    MINOR = 1
    TINY = 0

    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  NAME            = 'ActiveRecord::MultiConditions'
  GEM             = 'activerecord-multiconditions'
  AUTHOR          = 'Simone Carletti <weppos@weppos.net>'
  
  VERSION         = Version::STRING
  STATUS          = 'alpha'
  BUILD           = ''.match(/(\d+)/).to_a.first
  
  
  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    
    # Initialize a new +MultiConditions+ instance with +conditions+.
    #
    # This is the preferred way to initialize a new +MultiConditions+ instance.
    # If you want to initialize a MultiConditions youself you must be sure
    # to pass current Active Record class as the first parameter.
    #
    #   Task.multiconditions(['active = ? AND query LIKE ?', true, '%foo'])
    #   # => Task::MultiConditions
    # 
    #   Task.multiconditions(:foo => 'bar')
    #   # => Task::MultiConditions
    #
    def multiconditions(condition = nil, &block)
      InstanceMethods::MultiConditions.new(self, condition, &block)
    end
    alias :multicondition :multiconditions
    
  end
  
  module InstanceMethods

    class MultiConditions

      # Conditions collection
      attr_reader :conditions

      # 
      # Creates a new MultiConditions instance and initializes it with +conditions+.
      # 
      #   # empty instance
      #   c = MultiConditions.new
      # 
      #   # new instance with a first value
      #   c = MultiConditions.new(['condition = ?', 'value'])
      # 
      #   # initialization with block
      #   c = MultiConditions.new do |condition|
      #     condition.append_condition('foo = 1')
      #     condition.append_condition('bar = 2')
      #     condition.append_condition(:baz => 3)
      #   end
      #
      def initialize(klass, condition = nil, &block) # :yields: self
        @conditions = []
        @klass = klass
        append_condition(condition)
        yield(self) if block_given?
        self
      end

      # Appends a new condition at the end of condition list.
      def append_condition(condition)
        @conditions.push(prepare_condition(condition))    unless condition.nil?
      end

      # Prepends a new condition at the beginning of condition list.
      def prepend_condition(condition)
        @conditions.unshift(prepare_condition(condition)) unless condition.nil?
      end

      # Returns a :conditions suitable representation of this object
      # 
      #   c = ModelClass.multiconditions do |condition|
      #     condition.append_condition('foo = 1')
      #     condition.append_condition('bar = 2')
      #     condition.append_condition(:baz => 3)
      #   end
      #   
      #   c.to_conditions
      #   # => 'foo = 1 AND bar = 2 AND baz = 3'
      #   
      #   # Example usage
      #   find(:all, :conditions => c.to_conditions)
      #
      def to_conditions
        @conditions.join(' AND ')
      end
      alias :to_s :to_conditions


      protected

        # normalize conditions to be stored
        # for now use active record :sanitize_sql_for_conditions
        # instead of dealing with custom methods.
        def prepare_condition(condition)
          @klass.send(:sanitize_sql_for_conditions, condition)
        end

    end
  end
end

class ActiveRecord::Base
  include MultiConditions
end