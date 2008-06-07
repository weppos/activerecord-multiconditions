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


module ActiveRecord
  class Base

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
    #   conditions = MultiConditions.new
    #   # ... do some elaboration
    #   conditions.append_condition(['active = ? AND query LIKE ?', true, '%foo']
    #   # ... other elaboration
    #   conditions.append_condition(['name = ?', 'aname']
    #   
    #   conditions.to_conditions
    #   # => "active = true AND query LIKE '%foo' AND name = 'aname'"
    # 
    # The MultiConditions object accepts any type of conditions supported by ActiveRecord,
    # including Strings, Arrays and Hashes, and merges them alltogether
    # just before sending the final :condition value to ActiveRecord search method.
    # 
    #   conditions = MultiConditions.new
    #   conditions.append_conditions(:foo => 1, :bar => 2)
    #   conditions.append_conditions('active = 1')
    #   conditions.append_conditions(['name LIKE ?', '%foo'])
    #   
    #   conditions.to_conditions
    #   # => 'foo = 1 AND :bar = 2 AND active = 1 AND name LIKE '%foo'
    #   
    # See ActiveRecord::Base#find documentation for more conditions examples.
    # 
    # 
    # == Important
    # 
    # Once loaded, this library become part of ActiveRecord package and
    # creates its own namespace at ActiveRecord::Base::MultiConditions.
    # 
    # For various reason, you cannot initialize a new ActiveRecord::Base::MultiConditions
    # but you *MUST* initialize a MultiConditions instance from a Model.
    # 
    #   # The wrong way
    #   # raises Message: <"undefined method `abstract_class?' for Object:Class">
    #   ActiveRecord::Base::MultiConditions.new
    #   
    #   # The right way
    #   class Model < ActiveRecord::Base
    #   
    #     def a_method()
    #       c = MultiConditions.new
    #       find(:all, :conditions => c.to_conditions)
    #     end
    #   
    #   end
    #   
    #
    class MultiConditions

      module Version #:nodoc:
        MAJOR = 0
        MINOR = 0
        TINY = 0

        STRING = [MAJOR, MINOR, TINY].join('.')
      end

      NAME            = 'ActiveRecord::MultiConditions'
      GEM             = 'activerecord-multiconditions'
      AUTHOR          = 'Simone Carletti <weppos@weppos.net>'
      VERSION         = defined?(Version) ? Version::STRING : nil
      STATUS          = 'alpha'
      BUILD           = ''.match(/(\d+)/).to_a.first


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
      def initialize(condition = nil, &block) # :yields: self
        @conditions = []
        append_condition(condition)
        yield(self) if block_given?
        self
      end

      # 
      # Appends a new condition at the end of condition list.
      # 
      def append_condition(condition)
        @conditions.push(prepare_condition(condition))    unless condition.nil?
      end

      # 
      # Prepends a new condition at the beginning of condition list.
      # 
      def prepend_condition(condition)
        @conditions.unshift(prepare_condition(condition)) unless condition.nil?
      end

      # 
      # Returns a :conditions suitable representation of this object
      # 
      #   c = MultiConditions.new do |condition|
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
          Task.send(:sanitize_sql_for_conditions, condition)
        end

    end

  end
end