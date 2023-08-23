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
        db.execute('SELECT full_name FROM students WHERE id=?', id).map{|item| item['full_name']}[0]
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

        db.execute('INSERT INTO game_data (game_id, first_or_full, complete, last_guess, last_correct_answer, lives) VALUES (?,?,?,?,?,?)', new_id, "first", "False", nil, nil, 3)

        new_id
    end

    def self.lose_a_life(game_id)
        lives = db.execute('SELECT lives FROM game_data WHERE game_id = ?', game_id)[0]['lives']
        db.execute('UPDATE game_data SET lives = ? WHERE game_id = ?', lives.to_i - 1, game_id)
        return "dead" if lives <= 1
    end

    def self.random_student_id_from_game(game_id)
        result = db.execute('SELECT student_id FROM games WHERE guessed = ? AND id = ?', "False", game_id)
        result.map!{|item| item['student_id']}
        result.sample
    end

    def self.update_last_guess(game_id, last_correct_answer, bool_string)
        db.execute('UPDATE game_data SET last_correct_answer = ?, last_guess = ? WHERE game_id = ?', last_correct_answer, bool_string, game_id)
    end

    def self.get_last_guess_and_answer(game_id)
        res = []
        res << db.execute('SELECT last_guess FROM game_data WHERE game_id = ?', game_id)[0]['last_guess']
        res << db.execute('SELECT last_correct_answer FROM game_data WHERE game_id = ?', game_id)[0]['last_correct_answer']
    end

    def self.clear_last_guess(game_id)
        db.execute('UPDATE game_data SET last_guess = NULL, last_correct_answer = NULL WHERE game_id = ?', game_id)
    end

    def self.set_guessed_to_true(student_id, game_id)
        db.execute('UPDATE games SET guessed = "True" WHERE student_id = ? AND id = ?', student_id, game_id)
    end

    def self.check_lives(game_id)
        db.execute('SELECT lives FROM game_data WHERE game_id = ?', game_id)[0]['lives']
    end

    def self.check_if_dead(game_id)
        lives = check_lives(game_id)
        lives <= 0
    end

    def self.check_if_game_over(game_id)
        db.execute('SELECT * FROM games WHERE id = ? AND guessed = "False"', game_id) == []
    end

    def self.set_to_first_or_full(first_or_full, game_id)
        db.execute('UPDATE game_data SET first_or_full = ? WHERE game_id = ?', first_or_full, game_id)
    end

    def self.check_if_first_or_full(game_id)
        db.execute('SELECT first_or_full FROM game_data WHERE game_id = ?', game_id)[0]['first_or_full']
    end

    def self.percentage_and_fraction_guessed(game_id)
        guessed_amount = (db.execute('SELECT student_id FROM games WHERE guessed = ? AND id = ?', 'True', game_id).count)
        full_amount = self.all.count
        percent = ((guessed_amount.to_f / full_amount.to_f) * 100).to_i

        [percent, [guessed_amount.to_i, full_amount.to_i]]
    end

    private 
    def self.db 
        return @db if @db   #return @db if it exists XD
        @db = SQLite3::Database.new('db/students.db')
        @db.results_as_hash = true
        @db
    end
end