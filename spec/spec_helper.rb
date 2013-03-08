require 'pg'
require 'rspec'
require 'validatable'
require 'item'
require 'author'


DB = PG.connect(:dbname => 'library_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM collection *;")
    DB.exec("DELETE FROM items *;")
    DB.exec("DELETE FROM authors *;")
  end
end