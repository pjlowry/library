require 'pg'
require './lib/item'


DB = PG.connect(:dbname => 'library')

def welcome
  puts "Welcome to the Epicodus Library"
  main_menu
end


def main_menu
  choice = nil
  until choice == 'x'
    puts "Main Menu Options:"
    puts "For librarian options menu press 'l'"
    puts "For patron options menu press 'p'"
    puts "To exit the library press 'x':" 
    choice = gets.chomp.downcase
    case choice
    when 'l'
      librarian_menu
    when 'p'
      patron_menu
    when 'x'
      exit
    else 
      invalid
    end
  end
end

def librarian_menu
  choice = nil
  until choice == 'm'
    puts "You are in the librarian menu."
    puts "Press 'm' to return to the main menu."
    puts "Press 'a' to add a new item or 'd' to delete an item."
    choice = gets.chomp.downcase
    case choice
    when 'a'
      add_item
    when 'd'
      delete_item
    when 'm'
      exit
    else
      invalid
    end
  end
end

def patron_menu
  choice = nil
  until choice == 'm'
    puts "You are in the patron menu."
    puts "Press 's' to search for an item."
    puts "Press 'o' to check out an item."
    puts "Press 'i' to check in an item."
    puts "Press 'm' to return to the main menu."
    choice = gets.chomp.downcase
    case choice
    when 's'
      view
    when 'm'
      exit
    when 'o'
      check_out
    when 'i'
      check_in
    else 
      invlaid
    end
  end
end

def add_item
  puts "Please enter the item's media type:"
  type = gets.chomp
  puts "Please enter the item's title:"
  title = gets.chomp.capitalize
  puts "Please enter the item's author/artist:"
  author = gets.chomp.capitalize
  puts "Please enter the item's location:"
  location = gets.chomp.capitalize
  new_item_attributes = {'type' => type, 'title' => title, 'author' => author, 'location' => location}
  item = Item.new(new_item_attributes)
  puts "Do you want to add #{title} by #{author} as a #{type} at #{location} library? (y/n)"
  choice = gets.chomp.downcase
  if choice == 'y'
    item.save
    puts "#{title} by #{author} was added as a #{type} at #{location} library."
  else
    librarian_menu
  end
end

def view
  item = nil
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
  elsif search_method == 'a'
    item = author_search
  else
    invalid
  end
  item.view
end

def librarian_search
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    puts "Please enter the title of the item you would like to search for."
    title = gets.chomp.capitalize
    search_result = Item.find_by_title(title)
    puts "Your search returned the following results:"
    puts "#{search_result.title} by #{search_result.author}"
    puts "Would you like to delete that item (y/n)?"
    choice = gets.chomp
      if choice == 'y'
        delete_item
        puts "DELETED: #{search_result.title} by #{search_result.author} "
      else #####################
      end
  elsif search_method == 'a'
     puts "Please enter the author/artist of the item you would like to search for."
    author = gets.chomp.capitalize
    search_result = Item.find_by_author(author)
    puts "Your search returned the following results:"
    puts "#{search_result.title} by #{search_result.author}"
  end
end

def delete_item
  item = nil
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
  elsif search_method == 'a'
    item = author_search
  else
    invalid
  end
  puts "Are you sure you want to delete #{item.title} by #{item.author} (y/n)?" 
  choice = gets.chomp
  if choice == 'y'
    item.remove
    puts "#{item.title} by #{item.author} has been removed."
  end
  librarian_menu
end

# def search
#   puts "Please enter the title of the item you would like to search for."
#   title = gets.chomp.capitalize
#   search_result = Item.find_by_title(title)
#   puts "Your search returned the following results:"
#   puts "#{search_result.title} by #{search_result.author}"
#   item_to_be_deleted = search_result
# end

def title_search
  puts "Please enter the title of the item you would like to search for."
  title = gets.chomp.capitalize
  search_result = Item.find_by_title(title)
  unless search_result == nil
    puts "Your search returned the following results:"
    puts "#{search_result.title} by #{search_result.author}"
    search_result
  else
    puts "Title not found."
    patron_menu
  end
end

def author_search
  puts "Please enter the author/artist of the item you would like to search for."
  author = gets.chomp.capitalize
  search_result = Item.find_by_author(author)
  unless search_result == nil
    puts "Your search returned the following results:"
    puts "#{search_result.title} by #{search_result.author}"
    search_result
  else
    puts "Author/Artist not found."
    patron_menu
  end
end

def check_out
  item = nil
  puts "To check out an item you need to find it first."
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
  elsif search_method == 'a'
    item = author_search
  else
    invalid
    patron_menu
  end
  if item.available? == true
    puts "This item is available."
    puts "Would you like to check it out? (y/n)"
      gets.chomp.downcase == 'y'
        item.check_out
        puts "You have checked out #{item.title} by #{item.author}"
        puts "Don't forget to bring it back..."
  else
    puts "This item is unavailable."
  end
end

def check_in
  item = nil
  puts "To check in an item you need to find it first."
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
  elsif search_method == 'a'
    item = author_search
  else
    invalid
  end
  if item.available? == false
    puts "This item is checked out."
    puts "Would you like to check it back in? (y/n)"
      gets.chomp.downcase == 'y'
        item.check_in
        puts "You have checked in #{item.title} by #{item.author}"
        puts "Thanks!"
  else
    puts "This item is not checked out."
  end
end

# def attributes_of_an_item
#   Location:
#   Title:
#   Author/Artist:
    # Availability:

# end

def exit
  puts "Goodbye."
end

def invalid
  puts "Invalid entry."
end

welcome