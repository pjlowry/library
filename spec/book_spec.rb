require 'spec_helper'

describe Book do 
  context '#initialize' do 
    it 'initializes an instance of a book' do 
      book = Book.new('Of Mice and Men', 'John Steinbeck')
      book
    end
  end

  context '#save' do 
    it 'adds a book with a title and author and avialability to the collection database' do 
      book = Book.new('Grapes of Wrath', 'John Steinbeck')
      book.save
      Book.find_by_title("Grapes of Wrath").should eq book
    end
  end

  context '.find_by_title' do 
    it 'finds a book with a matching title' do 
      book = Book.new('Grapes of Wrath', 'John Steinbeck')
      book.save
      Book.find_by_title("Grapes of Wrath").should eq book
    end
  end
  
  context '#available?' do 
    it 'checks if a book is available and returns true or false' do 
      book = Book.new('Grapes of Wrath', 'John Steinbeck')
      book.save
      book.available?.should be_true
    end
  end

  context '#check_out' do
    it 'changes availability to false for the book in the collection' do
      book = Book.new('Grapes of Wrath', 'John Steinbeck')
      book.save
      book.check_out
      book.available?.should be_false
    end
  end
end