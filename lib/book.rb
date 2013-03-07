class Book
  attr_reader :author, :title, :record_id
  def initialize(title, author, record_id)
    @author = author
    @title = title
    @record_id = record_id
  end

  def save
    @record_id = DB.exec("INSERT INTO collection (title, availability) VALUES ('#{title}', 't') RETURNING id;").map {|result| result['id']}.first.to_i
    # p @record_id
    DB.exec("INSERT INTO items (record_id, author, title) VALUES (#{@record_id}, '#{author}', '#{title}');")
    # p DB.exec("SELECT * FROM items WHERE record_id = #{@record_id};")
  end

  def self.find_by_title(title)
    DB.exec("SELECT * FROM items WHERE title = '#{title}';").inject([]) { |items, book_hash| items << Book.new(book_hash['title'], book_hash['author'], book_hash['record_id']) }.first

  end

  # def available?
  #   if DB.exec("SELECT * FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, book_hash| items << Book.new(book_hash['availability'], book_hash['title'])} == 'f'
  #     false
  #   elsif DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, book_hash| items << book_hash['availability']}[0] == 't'
  #     true
  #   else
  #     DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, book_hash| items << book_hash['availability']}
  #   end
  # end

  def available?
    available = DB.exec("SELECT * FROM collection WHERE id = #{@record_id};").map {|result| result['availability']}.first
    if available == 'f'
      false
    elsif available == 't'
      true
    else
      "This book has unknown availability"
    end
  end

  def check_out
    DB.exec("UPDATE collection SET availability = false WHERE id = #{@record_id};")
  end

  def check_in
    DB.exec("UPDATE collection SET availability = true WHERE id = #{@record_id};")
  end

  def ==(other)
    if self.class != other.class
      false
    else
      self.title == other.title && self.author == other.author
    end
  end
end