class App < Sinatra::Base


    get '/quiz' do
        erb :quiz
    end

    get '/cheatsheet' do
        @ids = Students.all_ids
        erb :cheatsheet
    end

    get '/new-entry' do
        erb :new_entry
    end 

    post '/quiz' do
        
    end

end