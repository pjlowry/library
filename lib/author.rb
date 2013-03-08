class Author
  attr_reader :first_name, :last_name, :author_id
  def initialize(author_hash)
    @first_name = author_hash['first_name']
    @last_name = author_hash['last_name']
    @author_id = author_hash['id'].to_i
  end

  def full_name
    @first_name + " " + @last_name
  end

  def author_case
    author_name = "#{@first_name} #{@last_name}".to_s
    author_name.gsub!(/\b./) { |match| match.upcase }
    author_name.gsub!(/\B./) { |match| match.downcase }
    # author_name.gsub!(/\bvan\b|\bvon\b|\bdi\b|\bda\b|\bde\b|\bdo\b|\bdes\b|\bder\b|\bden\b/) { |match| match.downcase }
    # author_name.gsub!(/\bvan\b|\bvon\b|\bdi\b|\bda\b|\bde\b|\bdo\b|\bdes\b|\bder\b|\bden\b/) { |match| match.downcase }
    author_name.gsub!(/\b[a-z]\w*\z/i) { |match| match.capitalize }
    author_name.gsub!(/(?<=mac|mc)[a-z]/i) { |match| match.upcase }
    # author_name.gsub!(/(?<=')[a-z]/i) { |match| match.downcase }
    author_name.gsub!(/[-'][a-z]/i) { |match| match.upcase }
    author_name.gsub!(/\A[a-z]/i) { |match| match.upcase }
    author_name
  end

  def valid?
    !!@last_name.match(/[a-zA-Z0-9]+/) && (@first_name == '' || @first_name == nil || !!@first_name.match(/[a-zA-Z0-9]+/))
  end

  def matches_existing?
    DB.exec("SELECT * FROM authors WHERE last_name ~* '.*#{@last_name}.*';").inject([]) do |authors, author_hash|
      authors << Author.new(author_hash)
    end.first.class == self.class
  end

  def return_matches
    DB.exec("SELECT * FROM authors WHERE last_name ~* '.*#{@last_name}.*';").inject([]) do |authors, author_hash|
      authors << Author.new(author_hash)
    end
  end

  def save
    @author_id = DB.exec("INSERT INTO authors (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;").map {|result| result['id']}.first.to_i
  end

  def ==(other)
    if self.class != other.class
      false
    else
      self.first_name == other.first_name && self.last_name == other.last_name
    end
  end
end

# def capitalize_author_name(author_name)
#   if author_name.include?()
# end