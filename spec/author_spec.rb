require 'spec_helper'

describe Author do 
  context '#initialize' do 
    it 'initializes an author with a first and last name' do 
      author = Author.new('first_name' => 'John', 'last_name' => 'Steinbeck')
    end
  end

  context '#valid?' do 
    it 'tells us that an authors name can not be #%!@#$' do 
      author = Author.new('first_name' => 'bob', 'last_name' => '#%!@#$')
      author.valid?.should be_false
    end

    it 'tells us that an authors name can not be blank' do 
      author = Author.new('first_name' => 'bob', 'last_name' => '')
      author.valid?.should be_false
    end

    it 'tells us that an authors name can be bob' do 
      author = Author.new('last_name' => 'bob', 'first_name' => '20#%6')
      author.valid?.should be_true
    end
  end

  context '#author_case' do
    it 'capitalizes the author first and last name' do 
      author = Author.new({'first_name' => "o'reilly", 'last_name' => 'otto'})
      author.author_case.should eq "O'Reilly Otto"
    end

    it 'capitalizes the author first and last name' do 
      author = Author.new({'first_name' => 'ronald', 'last_name' => 'macdonald'})
      author.author_case.should eq "Ronald MacDonald"
    end

    it 'capitalizes the author first and last name' do 
      author = Author.new({'first_name' => 'gruber', 'last_name' => 'mcfarley'})
      author.author_case.should eq "Gruber McFarley"
    end

    it 'capitalizes the author first and last name' do
      author = Author.new({'first_name' => 'vincent', 'last_name' => "d'onorfrio"})
      author.author_case.should eq "Vincent D'Onorfrio"
    end

    # it 'capitalizes the author first and last name' do 
    #   author = Author.new({'first_name' => 'vanessa', 'last_name' => 'da mata'})
    #   author.author_case.should eq 'Vanessa da Mata'
    # end

    # it 'capitalizes the author first and last name' do 
    #   author = Author.new({'first_name' => 'vincent', 'last_name' => 'van gogh'})
    #   author.author_case.should eq 'Vincent van Gogh'
    # end

  end

  context '#matches_existing?' do 
    it 'checks to see if an author is previousily in our database, if the author is not in the database it returns false' do 
      author = Author.new('first_name' => 'Bob', 'last_name' => 'Jones')
      author.matches_existing?.should be_false
    end

    it 'checks to see if an author is previousily in our database, if the author is not in the database it returns false' do 
      author = Author.new('first_name' => 'Bob', 'last_name' => 'Jones')
      author.save
      author.matches_existing?.should be_true
    end
  end

  context '#return_matches' do
    it 'returns authors with matching last_names' do
      author1 = Author.new('first_name' => 'Gruber', 'last_name' => 'McFarley')
      author1.save
      author2 = Author.new('last_name' => 'Farle')
      author2.return_matches.should eq [author1]
    end
  end

  context '#save' do 
    it 'saves an author to the database' do 
      author = Author.new('first_name' => 'John', 'last_name' => 'Steinbeck')
      author.save
      author.matches_existing?.should be_true
    end
  end
end