require 'spec_helper'
test_attributes_hash = {'title' => 'grapes of wrath', 'record_id' => 44, 'location' => 'central', 'type' => 'book', 'author_id' => 99}

# class TestClass
#   include Validatable
# end

# describe TestClass do 
#   context '#valid?' do 
#     it 'tells us that an authors name can not be 20#%6' do 
#       author = Author.new()
#       test = TestClass.new
#       test.valid?.should be_false
#     end
#   end
# end

describe Item do

  context '#save' do 
    it 'adds a item with a title and author and avialability to the collection database' do 
      item = Item.new(test_attributes_hash)
      item.save
      Item.find_by_title("Grapes of Wrath").should eq item
    end
  end

  context '#record_id' do 
    it 'tells us the record id of a item' do 
      item = Item.new(test_attributes_hash)
      item.record_id.should eq 44
      item.save
      #item.record_id.should eq 44
    end
  end

  context '#title_case' do
    it 'capitalizes each principle word' do 
      item = Item.new(test_attributes_hash)
      item.title_case.should eq "Grapes of Wrath"
    end
  end 
  # context '.find_by_title' do 
  #   it 'finds a item with a matching title' do 
  #     item = Item.new(test_attributes_hash)
  #     item.save
  #     Item.find_by_title("Grapes of Wrath").should eq item
  #   end
  # end

  # context '.find_by_author' do 
  #   it 'finds a item with a matching author' do 
  #     item = Item.new(test_attributes_hash)
  #     item.save
  #     Item.find_by_author("John Steinbeck").should eq item
  #   end
  # end

  context '.find_by_author_id' do 
    it 'finds an item with a matching author id' do 
      item = Item.new(test_attributes_hash)
      item.save
      Item.find_by_author_id(item.author_id).should eq item
    end
  end
  
  context '#available?' do 
    it 'checks if a item is available and returns true or false' do 
      item = Item.new(test_attributes_hash)
      item.save
      # puts "Look here: #{item.available?}"
      item.available?.should be_true
    end
  end

  context '#check_out' do
    it 'changes availability to false for the item in the collection' do
      item = Item.new(test_attributes_hash)
      item.save
      item.check_out
      # puts "Look here: #{item.available?}"
      item.available?.should be_false
    end
  end

  context '#check_in' do
    it 'changes availability to true for the item in the collection' do
      item = Item.new(test_attributes_hash)
      item.save
      item.check_out
      item.check_in
      # puts "Look here: #{item.available?}"
      item.available?.should be_true
    end
  end

  context '#remove' do  
    it 'removes an item from the database' do 
      item = Item.new(test_attributes_hash)
      item.save
      item.remove
      item.available?.should be_false
    end
  end

  context '#view' do  
    it 'displays an item from the database' do 
      item = Item.new(test_attributes_hash)
      item.save
      item.view.should eq item
    end
  end

context '#view' do  
    it 'displays false if an item is not in the database' do 
      item = Item.new({'title' => 'bubba', 'record_id' => 435, 'location' => 'north', 'type' => 'music'})
      p item.view.should eq "Item not found."
    end
  end
end