class App < Sinatra::Base

    get '/' do
        erb :start
    end
    
    get '/quiz_start' do
        erb :quiz_start
    end

    get '/quiz/:game_id' do

        @game_id = params[:game_id]

        if Students.check_if_game_over(@game_id)
            redirect('/success')
        end

        if Students.check_if_dead(@game_id)
            redirect('/death')
        end

        @heart_images = []
        lives = Students.check_lives(@game_id)
        lives.times do
            @heart_images << "fullheart"
        end

        (3 - lives).times do 
            @heart_images << "emptyheart"
        end

        @id = Students.random_student_id_from_game(@game_id)
        @full_name = Students.name_from_id(@id)
        @last_guess = Students.get_last_guess_and_answer(@game_id)

        percent_and_fraction = Students.percentage_and_fraction_guessed(@game_id)
        @percent_of_guessed = percent_and_fraction[0]
        @fraction_of_guessed = percent_and_fraction[1]
        @progress_bar = ""

        @fraction_of_guessed[0].times do
            @progress_bar += "🟩"
        end

        (@fraction_of_guessed[1] - @fraction_of_guessed[0]).times do
            @progress_bar += "🟥"
        end


        if Students.check_if_first_or_full(@game_id) == 'first'
            @mode = 'First Name Only Mode'
        else
            @mode = 'Full Name Mode'
        end


        erb :quiz
    end

    get '/cheatsheet' do
        @students = Students.all
        erb :cheatsheet
    end

    get '/success' do
        erb :success
    end

    get '/death' do
        erb :death
    end

    post '/quiz/:game_id/:student_id' do
        student_id = params[:student_id]
        game_id = params[:game_id]
        correct_answer = Students.name_from_id(student_id)

        if Students.check_if_game_over(game_id)
            redirect('')
        end
        

        if Students.check_if_first_or_full(game_id) == 'first'
            correct_answer = correct_answer.split[0]
        end

        if params[:student_name] == "🇷🇴"
            redirect('https://www.gov.ro/')
        elsif params[:student_name].downcase == correct_answer.downcase
            Students.set_guessed_to_true(student_id, game_id)
            Students.update_last_guess(game_id, "True", correct_answer)
        else
            Students.update_last_guess(game_id, "False", correct_answer)
            if Students.lose_a_life(game_id) == "dead"
                redirect('/death')
            end
        end
        

        redirect("/quiz/#{game_id}")
    end

    post'/:game_id/mode_toggle' do
        game_id = params[:game_id]
        Students.clear_last_guess(game_id)

        if Students.check_if_first_or_full(game_id) == 'first'
            Students.set_to_first_or_full('full', game_id)
        else
            Students.set_to_first_or_full('first', game_id)
        end

        redirect("/quiz/#{game_id}")
    end

    post '/quiz_start' do
        students = Students.all
        game_id = Students.create_new_game(students.count)
        if params[:first_name_only_mode] 
            Students.set_to_first_or_full("first", game_id)
        else
            Students.set_to_first_or_full("full", game_id)
        end

        redirect("/quiz/#{game_id}")
    end
end