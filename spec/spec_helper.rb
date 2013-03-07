require 'pg'
require 'rspec'
require 'item'


DB = PG.connect(:dbname => 'library_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM collection *;")
    DB.exec("DELETE FROM items *;")
  end
end