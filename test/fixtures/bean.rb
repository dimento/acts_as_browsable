class Bean < ActiveRecord::Base
  acts_as_browsable
end

class CategorizedBean < ActiveRecord::Base
  acts_as_browsable :scope => [:category] # should be scope
  set_table_name 'beans'
end
