class Bean < ActiveRecord::Base
  acts_as_browsable
end

class CategorizedBean < ActiveRecord::Base
  acts_as_browsable :scope => :category
  set_table_name 'beans'
end

# class CategorizedReversedBean < ActiveRecord::Base
#   acts_as_browsable :scope => :category, :order => :desc
#   set_table_name 'beans'
# end