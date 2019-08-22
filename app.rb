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
    set :key_peg_values => {
      "1" => "perfect-match",
      "0" => "partial-match"
    }
    # enable secure sessions
  end

  configure :development do
    register Sinatra::Reloader
    enable :sessions
    set :session_secret, "secret"
  end

  def get_guess_cells_from_params(params)
    guess = []
    session[:game].code_length.times do |count|
      guess << params["color-#{count+1}"] unless params["color-#{count+1}"].nil?
    end

    guess.map { |color| Cell.new(color) }
  end

  get '/' do
    @session = session
    @game = session[:game]

    erb :index 
  end

  post '/' do
    if session[:game]
      guess = get_guess_cells_from_params(params)
      matches = session[:game].get_code_matches(guess, session[:game].board.secret)
      session[:game].push_to_key_grid(matches)
      session[:game].push_to_decoding_grid(guess)
      session[:game].player_wins?(matches)
      session[:game].next_turn
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