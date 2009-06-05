plugin_test_dir = File.dirname(__FILE__)

require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'shoulda'

require 'active_record'
require 'active_record/fixtures'
require 'action_view'

require plugin_test_dir + '/../init.rb'
 
ActiveRecord::Base.logger = Logger.new(plugin_test_dir + "/debug.log")
 
ActiveRecord::Base.configurations = YAML::load(IO.read(plugin_test_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3mem")
ActiveRecord::Migration.verbose = false
load(File.join(plugin_test_dir, "db", "schema.rb"))
 
Dir["#{plugin_test_dir}/fixtures/*.rb"].each {|file| require file }

Fixtures.create_fixtures(File.dirname(__FILE__) + "/fixtures/", ActiveRecord::Base.connection.tables) 