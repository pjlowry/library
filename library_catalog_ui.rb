require 'pg'
require './lib/book'

DB = PG.connect(:dbname => 'library')

def welcome
  puts "Welcome to the Epicodus Library"
  main_menu
end


def main_menu
  choice = nil
  until choice == 'x'
    puts "Main Menu Options:"
    puts "Press 'l' if you are the librarian or press 'p' if you are a patron of the library or 'x' to exit the library." 
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
    puts "Press 'a' to add a new book."
    choice = gets.chomp.downcase
    case choice
    when 'a'
      add_book
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
    puts "Press 's' to search for a book."
    puts "Press 'm' to return to the main menu."
    choice = gets.chomp.downcase
    case choice
    when 's'
      search
    when 'm'
      exit
    else 
      invlaid
    end
  end
end

def add_book
  puts "Please enter the title of the book."
  title = gets.chomp.capitalize
  puts "Please enter the author of the book:"
  author = gets.chomp.capitalize
  book = Book.new(title, author)
  puts "Do you want to add #{title} by #{author} to the library? (y/n)"
  choice = gets.chomp.downcase
  if choice == 'y'
    book.save
    puts "#{title} by #{author} was added to the library."
  else
    librarian_menu
  end
end

def search
  puts "Please enter the title of the book you would like to search for."
  title = gets.chomp.capitalize
  search_result = Book.find_by_title(title)
  puts "Your search returned the following results:"
  puts "#{search_result.title} by #{search_result.author}"
  p search_result.available?
  if search_result.available? == true
    puts "This book is available."
    puts "Would you like to check it out? (y/n)"
      gets.chomp.downcase == 'y'
        search_result.check_out
  elsif search_result.available? == false
    puts "This book is unavailable."
  else
    puts "We're not sure if this book is available."
  end
  patron_menu
end


def exit
  puts "Goodbye."
end

def invalid
  puts "Invalid entry."
end

welcome