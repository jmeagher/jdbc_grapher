# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'java'
Dir["#{File.dirname(__FILE__)}/../lib/jar/*.jar"].each do |jar|
   require jar
end

java_import 'org.apache.hive.jdbc.HiveDriver'

# Initialize the Rails application.
JdbcGrapher::Application.initialize!
