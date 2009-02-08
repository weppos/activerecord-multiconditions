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


require 'test_helper'


class MultiConditionsTest < Test::Unit::TestCase
  
  def setup
  end
  
  # =========================================================================
  # Constructor behavior
  # =========================================================================
  
  def test_initialize
    assert_nothing_raised { Task.multiconditions }
  end
  
  def test_initialize_with_condition
    assert_nothing_raised do
      Task.multiconditions(:foo => 1)
      Task.multiconditions('foo = 1')
      Task.multiconditions(['foo = ?', 1])
    end
  end
  
  def test_initialize_with_block
    assert_nothing_raised do
      Task.multiconditions do |c|
        c.append_condition(:foo => 1)
        assert_equal(1, c.conditions.length)
      end
    end
  end

  
  # =========================================================================
  # Condition string
  # =========================================================================
  #
  # TODO: Consider to move check from a simple string to a real SQL query.
  #       Using a real query statement is more efficient and ensures 
  #       finder methods works as expected.
  # 
  # TODO: add test for with_scope and named_scope(s). 
  #
  
  def test_single_condition_string
    [{:foo => 'bar'}, "foo = 'bar'", ["foo = ?", 'bar'], ["foo = :foo", {:foo => 'bar'}]].each do |condition|
      mc = Task.multiconditions(condition)
      assert_match(/"?foo"? = 'bar'$/, mc.to_conditions)
    end
  end
  
  def test_single_condition_fixnum
    [{:foo => 1}, "foo = 1", ["foo = ?", 1], ["foo = :foo", {:foo => 1}]].each do |condition|
      mc = Task.multiconditions(condition)
      assert_match(/"?foo"? = 1$/, mc.to_conditions)
    end
  end
  
  def test_multiple_conditions
    first  = [{:foo => 'bar'}, "foo = 'bar'", ["foo = ?", 'bar'], ["foo = :foo", {:foo => 'bar'}]]
    second = [{:baz => 3}, "baz = 3", ["baz = ?", 3], ["baz = :baz", {:baz => 3}]]
    first.size.times do |index|
      mc = Task.multiconditions
      mc.append_condition(first[index])
      mc.append_condition(second[index])
      assert_match(/"?foo"? = 'bar'/, mc.to_conditions)
      assert_match(/"?baz"? = 3/, mc.to_conditions)
    end
  end
  
  def test_mixed_conditions
    first  = [{:foo => 'bar'}, "foo = 'bar'", ["foo = ?", 'bar'], ["foo = :foo", {:foo => 'bar'}]]
    second = ["baz = 3", ["baz = ?", 3], ["baz = :baz", {:baz => 3}], {:baz => 3}]
    first.size.times do |index|
      mc = Task.multiconditions
      mc.append_condition(first[index])
      mc.append_condition(second[index])
      assert_match(/"?foo"? = 'bar'/, mc.to_conditions)
      assert_match(/"?baz"? = 3/, mc.to_conditions)
    end
  end
  
  
  protected
    
    def instance(condition = nil)
      Task.multiconditions(condition)
    end
    
    def table_name
      Task.table_name
    end

end