class App < Sinatra::Base
    enable :sessions


    get '/' do
        erb :start
    end

    get '/quiz_start' do
        erb :quiz_start
    end

    get '/quiz/:game_id' do
        @id = Students.random_student_id_from_game(params[:game_id])
        @full_name = Students.name_from_id(@id)
        erb :quiz
    end

    get '/cheatsheet' do
        @students = Students.all
        erb :cheatsheet
    end

    get '/new_entry' do
        erb :new_entry
    end 

    post '/quiz' do
        #check if answer was correct:
        #if correct, set guessed? in database to True
        #also set session[:last_guess] to True
        #else set session[:last_guess] to False
        redirect("/quiz/#{@game_id}")
    end

    post '/quiz_start' do
        @students = Students.all
        @game_id = Students.create_new_game(@students.count)
        session[:last_guess] = nil
        redirect("/quiz/#{@game_id}")
    end
end