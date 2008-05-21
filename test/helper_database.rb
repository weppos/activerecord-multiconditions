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


# reset database
database = File.dirname(__FILE__) + '/db/test.sqlite3'
File.delete(database) if File.file? database

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => database
)

# define a migration
class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title
    end
  end

  def self.down
    drop_table :title
  end
end

# run the migration
CreateTasks.migrate(:up)

# define a simple model 
class Task < ActiveRecord::Base
end
