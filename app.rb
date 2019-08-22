class Mastermind < Sinatra::Base
  configure do
    set :colors => {
      "1" => "red",
      "2" => "green",
      "3" => "blue",
      "4" => "yellow",
      "5" => "brown",
      "6" => "orange",
      "7" => "black",
      "8" => "white"
    }
    # enable secure sessions
  end

  def get_guess_cells_from_params(params)
    guess = []
    session[:game].code_length.times do |count|
      guess << params["color-#{count+1}"] unless params["color-#{count+1}"].nil?
    end

    guess.map { |color| Cell.new(color) }
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
    if session[:game]
      guess = get_guess_cells_from_params(params)
      session[:game].push_to_decoding_grid(guess)
      params.clear
    else
      turns = params['turns'].to_i
      player = Player.new(role: params['role'].to_i)
      session[:game] = Game.new(turns: turns, player: player)
    end

    redirect '/'
  end

  post '/reset_game' do
    session.delete(:game)
    redirect '/'
  end

end