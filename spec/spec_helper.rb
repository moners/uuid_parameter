require "active_record"
require "uuid_parameter"

# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

# Make sure you include UUIDParameter in your model!
class User < ActiveRecord::Base; include UUIDParameter; end

# Store the UUID as a string.
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :uuid, limit: 36
    # t.uuid :uuid # For use with Postgres
  end
end

RSpec.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.connection.execute("DELETE FROM users WHERE 1 = 1;")
  end
end
