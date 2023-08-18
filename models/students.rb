class Students

    def self.all
        db.execute("SELECT * FROM students")
    end

    def self.all_ids
        db.execute('SELECT id FROM students').map{|item| item["id"]}
    end

    def self.fullname
        db.execute("SELECT name FROM students")
    end

    def self.name_from_id(id)
        db.execute("SELECT name FROM students WHERE id=?", id)
    end


    private 
    def self.db 
        return @db if @db   #return @db if it exists XD
        @db = SQLite3::Database.new("db/students.db")
        @db.results_as_hash = true
        @db
    end
end