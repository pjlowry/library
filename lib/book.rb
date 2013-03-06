class Book
  attr_reader :author, :title, :record_id
  def initialize(title, author)
    @author = author
    @title = title
    @record_id = 0
  end

  def save
    @record_id = DB.exec("INSERT INTO collection (title, availability) VALUES ('#{title}', true) RETURNING id;").map {|result| result['id']}.first.to_i
    DB.exec("INSERT INTO books (record_id, author, title) VALUES (#{@record_id}, '#{author}', '#{title}');")
  end

  def self.find_by_title(title)
    DB.exec("SELECT * FROM books WHERE title = '#{title}';").inject([]) { |books, book_hash| books << Book.new(book_hash['title'], book_hash['author']) }.first
  end

  # def available?
  #   if DB.exec("SELECT * FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |books, book_hash| books << Book.new(book_hash['availability'], book_hash['title'])} == 'f'
  #     false
  #   elsif DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |books, book_hash| books << book_hash['availability']}[0] == 't'
  #     true
  #   else
  #     DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |books, book_hash| books << book_hash['availability']}
  #   end
  # end

  def available?
    available = DB.exec("SELECT availability FROM collection WHERE id = #{@record_id};").map {|result| result['availability']}.first
    if available == 'f'
      false
    elsif available == 't'
      true
    else
      puts 'wtf'    
    end
  end

  def check_out
    DB.exec("UPDATE collection SET availability = false WHERE id = #{@record_id};")
  end

  def ==(other)
    if self.class != other.class
      false
    else
      self.title == other.title && self.author == other.author
    end
  end
end