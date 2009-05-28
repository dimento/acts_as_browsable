module Browsable
	module ViewHelpers
		@@pagination_options = {
		  :class          => 'browsable',
		  :wrapper		  	=> :ul,
		  :element		  	=> :li,
		  :previous_class => 'browseable_prev',
		  :next_class     => 'browseable_next',
		  :previous_label => '&laquo; Previous',
		  :next_label     => 'Next &raquo;'
		}
		mattr_reader :pagination_options
		
		# Returns a fully functional next and previous navigation for your model in your view.
		#
		# Configuration options are:
    # * <tt>wrapper</tt> - the wrapping HTML element for both links. :ul is default
		# * <tt>class</tt> - the HTML class for the wrapping HTML element. 'browsable' is default
    # * <tt>element</tt> - the wrapping element for each link. :li is default
    # * <tt>previous_class</tt> - the HTML class for the wrapping HTML element of the previous-link
    # * <tt>next_class</tt> -  - the HTML class for the wrapping HTML element of each next-link
    # * <tt>previous_label</tt> - the text/label for the previous-link
    # * <tt>next_label</tt> - the text/label for the next-link
		def browsable(collection, options = {})
			options = options.symbolize_keys.reverse_merge Browsable::ViewHelpers.pagination_options
			
			browsable_links = [ 
				{ 
					"class" => options[:previous_class], 
					"url" 	=> browsable_prev(collection, options, false) 
				},  
				{ 
					"class" => options[:next_class], 
					"url" 	=> browsable_next(collection, options, false) 
				}
			]
					
			content_tag(options[:wrapper], browsable_links.collect { |link| content_tag(options[:element], link["url"], :class => link["class"]) }, :class => options[:class])
		end
		
		def browsable_next(collection, options = {}, with_class = true)
			link_string = ""
	
			if next_entry = collection.next
				class_name = with_class ? options[:next_class] : nil
				link_string = link_to options[:next_label], next_entry, :class => class_name
			end
			
			link_string
		end
		
		def browsable_prev(collection, options = {}, with_class = true)
			link_string = ""
			if prev_entry = collection.prev
				class_name = with_class ? options[:previous_class] : nil
				link_string += link_to options[:previous_label], prev_entry, :class => class_name
			end
			
			link_string
		end
	end
end