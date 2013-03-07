class Item
  attr_reader :author, :title, :record_id
  
  def initialize(attributes_hash)
    @author = attributes_hash['author']
    @title = attributes_hash['title']
    @record_id = attributes_hash['record_id']
    @location = attributes_hash['location']
    @type = attributes_hash['type']
  end

  def save
    @record_id = DB.exec("INSERT INTO collection (location, availability) VALUES ('#{@location}', 't') RETURNING id;").map {|result| result['id']}.first.to_i
    DB.exec("INSERT INTO items (record_id, author, title, type) VALUES (#{@record_id}, '#{@author}', '#{@title}', '#{@type}');")
  end

  def self.find_by_title(title)
    DB.exec("SELECT * FROM items WHERE title = '#{title}';").inject([]) do |items, item_hash|
      items << Item.new({'title' => item_hash['title'], 'author' => item_hash['author'], 'record_id' => item_hash['record_id'], 'type' => item_hash['type']})
    end.first
  end

  def self.find_by_author(author)
    DB.exec("SELECT * FROM items WHERE author = '#{author}';").inject([]) do |items, item_hash|
      items << Item.new({'title' => item_hash['title'], 'author' => item_hash['author'], 'record_id' => item_hash['record_id'], 'type' => item_hash['type']})
    end.first
  end

  # def available?
  #   if DB.exec("SELECT * FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, item_hash| items << Item.new(item_hash['availability'], item_hash['title'])} == 'f'
  #     false
  #   elsif DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, item_hash| items << item_hash['availability']}[0] == 't'
  #     true
  #   else
  #     DB.exec("SELECT availability FROM collection WHERE id = #{@record_id.to_i};").inject([]) { |items, item_hash| items << item_hash['availability']}
  #   end
  # end

  def available?
    DB.exec("SELECT * FROM collection WHERE id = #{@record_id};").map {|result| result['availability']}.first == 't'
  end

  def check_out
    DB.exec("UPDATE collection SET availability = false WHERE id = #{@record_id};")
  end

  def check_in
    DB.exec("UPDATE collection SET availability = true WHERE id = #{@record_id};")
  end

  def remove
    DB.exec("DELETE FROM collection WHERE id = #{@record_id};")
    DB.exec("DELETE FROM items WHERE record_id = #{@record_id};")
  end

  def view
    item = DB.exec("SELECT * FROM items WHERE record_id = #{@record_id};").inject([]) do |items, item_hash|
      items << Item.new({'title' => item_hash['title'], 'author' => item_hash['author'], 'record_id' => item_hash['record_id'], 'type' => item_hash['type']})
    end.first

    if item == self
      item
    else
      "Item not found."
    end
  end

  def ==(other)
    if self.class != other.class
      false
    else
      self.title == other.title && self.author == other.author
    end
  end

end