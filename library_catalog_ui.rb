require 'pg'
require './lib/item'
require './lib/author'


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
      go_back
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
      puts "Going back to the main menu."
    when 'o'
      check_out
    when 'i'
      check_in
    else 
      go_back
    end
  end
end

def add_item
  puts "Please enter the appropriate information for the item."
  puts "Media type:"
  type = gets.chomp
  puts "Title:"
  title = gets.chomp
  puts "Author/artist's last name or if artist has only one name:"
  last_name = gets.chomp
  puts "Author/artist's first name if no name press enter:"
  first_name = gets.chomp
  author_attributes_hash = {'last_name' => last_name, 'first_name' => first_name}
  
  new_author = Author.new(author_attributes_hash)
  if new_author.matches_existing?
    puts "That name matches existing ones in the database:"
    matches = new_author.return_matches
    puts matches.each do |author_match|
      author_match.author_case
    end.join("\n")
  else
    puts "No matches were found in our system for that name."
    new_author.save
  end
  puts "Location:"
  location = gets.chomp
  new_item_attributes = {'type' => type, 'title' => title, 'author_id' => new_author.author_id, 'location' => location}
  new_item = Item.new(new_item_attributes)
  puts "Do you want to add #{new_item.title_case} by #{new_author.author_case} as a #{type} at #{location} library? (y/n)"
  choice = gets.chomp.downcase
  if choice == 'y'
    new_item.save
    puts "#{new_item.title_case} by #{new_author.author_case} was added as a #{type} at #{location} library."
  else
    go_back
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
    unless item == nil
      item.view
    end
  elsif search_method == 'a'
    item = author_search
    unless author_search == nil
      item.view
    end
  else
    invalid
  end
  go_back
end

def delete_item
  item = nil
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
    confirm_removal(item)
  elsif search_method == 'a'
    item = author_search
    confirm_removal(item)
  else
    invalid
  end
  go_back
end

def confirm_removal(item)
  puts "Are you sure you want to delete #{item.title_case} (y/n)?" 
  choice = gets.chomp
  if choice == 'y'
    item.remove
    puts "#{item.title_case} has been removed."
  end
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
    puts "#{search_result.title_case}"
    search_result
  else
    puts "Title not found."
  end
  go_back
end


def author_search
  puts "Enter the primary name of the author/artist:"
  puts "(If it is a person with a first and last name, enter the last name)"
  author_name = gets.chomp
  search_author = Author.new({'last_name' => author_name})
  unless search_author.matches_existing? == false
    matches = search_author.return_matches
    puts "Your search returned the following results:"
    matches.each do |author_match|
      puts author_match.author_case
    end
    matches.first
  else
    puts "Author/Artist not found."
  end
  go_back
end

# def author_search
#   puts "Please enter the author/artist of the item you would like to search for."
#   author = gets.chomp.capitalize
#   search_result = Item.find_by_author(author)
#   unless search_result == nil
#     puts "Your search returned the following results:"
#     puts "#{search_result.title} by #{search_result.author}"
#     search_result
#   else
#     puts "Author/Artist not found."
#     patron_menu
#   end
# end

def check_out
  item = nil
  puts "To check out an item you need to find it first."
  puts "Choose your search method:"
  puts "To search by title press 't'"
  puts "To search by author press 'a'"
  search_method = gets.chomp.downcase
  if search_method == 't'
    item = title_search
    confirm_check_out(item)
  elsif search_method == 'a'
    item = author_search
    confirm_check_out(item)
  else
    invalid
  end
  go_back
end

def confirm_check_out(item)
  unless item == nil
    if item.available? == true
      puts "This item is available."
      puts "Would you like to check it out? (y/n)"
        if gets.chomp.downcase == 'y'
          item.check_out
          puts "You have checked out #{item.title_case}"
          puts "Don't forget to bring it back..."
        else
          puts "Maybe next time..."
        end
    else
      puts "This item is unavailable."
    end
  else
    puts "No item to check out."
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
        puts "You have checked in #{item.title_case}"
        puts "Thanks!"
  else
    puts "This item is not checked out."
  end
  go_back
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

def go_back
  puts "Returning to the previous menu."
end

welcome