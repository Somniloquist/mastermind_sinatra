class Mastermind < Sinatra::Base
  configure do
    set :colors => {
      1 => "red",
      2 => "green",
      3 => "blue",
      4 => "yellow",
      5 => "brown",
      6 => "orange",
      7 => "black",
      8 => "white"
    }
    # enable secure sessions
  end

  configure :development do
    register Sinatra::Reloader
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    @session = session
    @game = session[:game]
    erb :index
  end

  post '/' do
    turns = params['turns'].to_i
    player = Player.new(role: params['role'].to_i)
    game = Game.new(turns: turns, player: player)

    # store the game
    session[:game] = game

    redirect '/'
  end

end