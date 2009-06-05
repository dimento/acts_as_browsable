begin
  require "active_support"
rescue LoadError
  require "rubygems"
  require "active_support"
end

require 'browsable/view_helpers'

module Dimento
  module Acts
    module Browsable
    	def self.included(base)
    		base.extend Browsable::ClassMethods
    		ActionView::Base.send :include, Browsable::ViewHelpers
    	end
	
    	module ClassMethods
    		# Specify a model as “acts_as_browsable” to get the browsable functionality for it. To 
    		# determine fields/attributes values that have to be equal for the next or previous 
    		# object, assign <tt>:scope</tt> with an array of desired fields. You can also define
    		# the <tt>:order</tt>.
    		#
    		# The following is the default usage
    		#
    		# 	class Post < ActiveRecord::Base
    		# 		acts_as_browsable
    		# 	end
    		# 
    		# The following usage ensures to return only those objects with the same attribute values 
    		# for language and customer_id of the recent object.
    		# 
    		# 	class Post < ActiveRecord::Base
    		# 		acts_as_browsable :equal_fields    => [ :language, :customer_id ]
    		# 	end
    		def acts_as_browsable(opts = {})
    			scope = opts.delete(:scope) || []
    			scope = [scope] unless scope.is_a? Array
    			write_inheritable_attribute(:browsable_scope, scope)
			
    			send :include, Browsable::InstanceMethods
    		end
    	end
	
    	module InstanceMethods
    		# Returns the next greater object of your model ordered by id.
    		# 	post.next #                         => returns the next post defined by your acts_as_browsable options
    		def next
    			step_by(:id, :next)
    		end
		
    		# Returns the next lower object of your model ordered by id.
    		# 	post.next #                         => returns the previous post defined by your acts_as_browsable options
    		# TODO: alias “previous”
    		def prev
    			step_by(:id, :prev)
    		end
		
    		# Returns the next greater object of your model ordered by the specified model attribute. 
    		# 	post.next_by(:title) #              => returns the next post ordered by title
    		def next_by(field)
    			step_by(field, :next)
    		end
		
    		# Returns the next lower object of your model ordered by the specified model attribute. 
    		# 	post.next_by(:category_id) #        => returns the previous post ordered by category_id
    		def prev_by(field)
    			step_by(field, :prev)      
    		end
	
    		# Returns the next object of your model ordered by the specified model attribute and the 
    		# desired direction.
    		# 	post.step_by( :title, :previous ) # => returns the next model object ordered by title
    		def step_by(field, direction)
    			desired_direction                     = direction == :next ? ">" : "<"
    			order_direction                       = direction == :next ? " ASC" : " DESC"
			
    			self.class.first :conditions          => prepare_condition(field, desired_direction, self.class.read_inheritable_attribute(:browsable_scope)), :order => field.to_s + order_direction
    		end    
    	end
	
    	protected
    	def prepare_condition(field, direction, scoped_fields)
    		unprepared_condition                   = "#{field.to_s} #{direction} :#{field.to_s}"
    		condition_values                       = { }
    		condition_values[field.to_sym]         = send(field.to_sym)
	
    		scoped_fields.each do |scoped_field|
    			unprepared_condition += " AND #{scoped_field.to_s} = :#{scoped_field.to_s}"
    			condition_values[scoped_field.to_sym]  = send(scoped_field.to_sym)
    		end
	
    		[unprepared_condition, condition_values]
    	end
    end
  end
end