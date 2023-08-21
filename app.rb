class App < Sinatra::Base
    enable :sessions


    get '/' do
        erb :start
    end

    get '/quiz_start' do
        erb :quiz_start
    end

    get '/quiz/:game_id' do
        @game_id = params[:game_id]
        @id = Students.random_student_id_from_game(@game_id)
        @full_name = Students.name_from_id(@id)
        p @id
        p @full_name
        @last_guess = session[:last_guess]
        erb :quiz
    end

    get '/cheatsheet' do
        @students = Students.all
        erb :cheatsheet
    end

    get '/new_entry' do
        erb :new_entry
    end 

    post '/quiz/:game_id/:student_id' do
        @student_id = params[:student_id]
        @game_id = params[:game_id]
        @correct_answer = Students.name_from_id(@student_id)

        if params[:student_name] == @correct_answer
            Students.set_guessed_to_true(@student_id)
            session[:last_guess] = [@correct_answer, true]
        else
            session[:last_guess] = [@correct_answer, false]
        end

        redirect("/quiz/#{@game_id}")
    end

    post '/quiz_start' do
        @students = Students.all
        @game_id = Students.create_new_game(@students.count)
        session[:last_guess] = nil
        redirect("/quiz/#{@game_id}")
    end
end