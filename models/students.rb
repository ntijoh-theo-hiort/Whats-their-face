class Students

    def self.all
        db.execute('SELECT * FROM students')
    end

    def self.all_ids
        db.execute('SELECT id FROM students').map{|item| item['id']}
    end

    def self.fullname
        db.execute('SELECT full_name FROM students').map{|item| item['name']}
    end

    def self.name_from_id(id)
        db.results_as_hash = false
        db.execute('SELECT full_name FROM students WHERE id=?', id)[0][0]
    end

    def self.create_new_game(student_amount)
        new_id = db.execute('SELECT MAX(id) FROM games')[0]["MAX(id)"]

        if !new_id
            new_id = 1
        else
            new_id += 1
        end

        i = 1
        until i > student_amount
            db.execute('INSERT INTO games (id, student_id, guessed) VALUES (?,?,?)', new_id, i, 'False')
            i += 1
        end

        new_id
    end

    def random_student_id_from_game(game_id)
        # get a random id from the 'games' table where guessed == "False"
    end

    def set_guessed_to_false(student_id)
        # set guessed to false in 'games' table where id matches argument for this method
    end

    private 
    def self.db 
        return @db if @db   #return @db if it exists XD
        @db = SQLite3::Database.new('db/students.db')
        @db.results_as_hash = true
        @db
    end
end