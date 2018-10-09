class Dog 
  attr_accessor :id, :name, :breed 
  
  def initialize(name:, breed:, id: nil)
    @name = name 
    @breed = breed 
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT, 
      breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end 
  
  def save
    if self.id 
      self.update 
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end 
    self
  end
  
  def self.create(name:, breed:)
    dog = self.new(name: name, breed: breed)
    dog.save 
    dog
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * 
      FROM dogs 
      WHERE id = ?
    SQL
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(name: result[1], breed: result[2], id: result[0])
  end 
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = self.new(name: dog_data[1], breed: dog_data[2], id: dog_data[0])
    else 
      dog = self.create(name: name, breed: breed)
    end 
    dog
  end 
  
  def new_from_db(row)
    dog = 
  
end 



