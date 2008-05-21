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


require File.dirname(__FILE__) + '/../helper'


class MultiConditionsTest < Test::Unit::TestCase
  
  def setup
    
  end
  
  # =========================================================================
  # Constructor behavior
  # =========================================================================
  
  def test_initialize
    assert_nothing_raised() do
      assert_kind_of(Task::MultiConditions, ActiveRecord::Base::MultiConditions.new)
    end
  end
  
  def test_initialize_with_condition
    assert_nothing_raised() do
      Task::MultiConditions.new(:foo => 1)
      Task::MultiConditions.new('foo = 1')
      Task::MultiConditions.new(['foo = ?', 1])
    end
  end
  
  def test_initialize_with_block
    assert_nothing_raised() do
      obj = Task::MultiConditions.new do |c|
        c.append_condition(:foo => 1)
        assert_equal(1, c.conditions.length)
      end
      # ensure initialize always returns self
      assert_kind_of(ActiveRecord::Base::MultiConditions, obj)
    end
  end
  
  def instance(condition = nil)
    Task::MultiConditions.new(condition)
  end

end