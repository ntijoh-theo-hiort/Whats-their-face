class App < Sinatra::Base


    get '/quiz' do
        erb :quiz
    end

    get '/cheatsheet' do
        erb :cheatsheet
    end

    get '/new-entry'
        erb :new_entry
    end 
    

end