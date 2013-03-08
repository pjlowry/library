class Item
  attr_reader :title, :record_id, :author_id
  
  def initialize(attributes_hash)
    @author_id = attributes_hash['author_id'].to_i
    @title = attributes_hash['title']
    @record_id = attributes_hash['record_id'].to_i
    @location = attributes_hash['location']
    @type = attributes_hash['type']
  end

  def title_case
    title = @title
    title.gsub!(/\b./) { |match| match.upcase }
    title.gsub!(/\B./) { |match| match.downcase }
    title.gsub!(/\ba\b|\ban\b|\bthe\b|\band\b|\bbut\b|\bfor\b|\bnor\b|\bor\b|\bso\b|\byet\b|\babout\b|\babove\b|\bacross\b|\bafter\b|\bagainst\b|\balong\b|\bamong\b|\baround\b|\bat\b|\bbefore\b|\bbehind\b|\bbelow\b|\bbeneath\b|\bbeside\b|\bbetween\b|\bbeyond\b|\bbut\b|\bby\b|\bdespite\b|\bdown\b|\bduring\b|\bexcept\b|\bfor\b|\bfrom\b|\bin\b|\binside\b|\binto\b|\blike\b|\bnear\b|\bof\b|\boff\b|\bon\b|\bonto\b|\bout\b|\boutside\b|\bover\b|\bpast\b|\bsince\b|\bthrough\b|\bthroughout\b|\btill\b|\bto\b|\btoward\b|\bunder\b|\bunderneath\b|\buntil\b|\bup\b|\bupon\b|\bwith\b|\bwithin\b/i) { |match| match.downcase }
    title.gsub!(/\b[a-z]\w*\Z/i) { |match| match.capitalize }
    title.gsub!(/(?<=')[a-z]/i) { |match| match.downcase }
    title.gsub!(/[.:!?-]+\W+[a-z]/i) { |match| match.upcase }
    title.gsub!(/\A[a-z]/i) { |match| match.upcase }
    title
  end

  def save
    @record_id = DB.exec("INSERT INTO collection (location, availability) VALUES ('#{@location}', 't') RETURNING id;").map {|result| result['id']}.first.to_i
    DB.exec("INSERT INTO items (title, record_id, author_id, type) VALUES ('#{@title}', #{@record_id}, #{@author_id}, '#{@type}');")
  end

  def self.find_by_title(title)
    DB.exec("SELECT * FROM items WHERE title ~* '.*#{title}.*';").inject([]) do |items, item_hash|
      items << Item.new(item_hash)
    end.first
  end

  # def self.find_by_author(author)
  #   DB.exec("SELECT * FROM items WHERE author = '#{author}';").inject([]) do |items, item_hash|
  #     items << Item.new({'title' => item_hash['title'], 'author' => item_hash['author'], 'record_id' => item_hash['record_id'], 'type' => item_hash['type']})
  #   end.first
  # end

  def self.find_by_author_id(author_id)
    DB.exec("SELECT * FROM items WHERE author_id = #{author_id};").inject([]) do |items, item_hash|
      items << Item.new(item_hash)
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
      items << Item.new(item_hash)
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
      self.title == other.title && self.author_id == other.author_id
    end
  end

end