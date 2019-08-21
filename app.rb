class Mastermind < Sinatra::Base
  configure do
    # enable secure sessions
  end

  def add_guess_to_board(params)
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
      guess = add_guess_to_board(params)
      session[:game].push_to_decoding_grid(guess)
      params.clear
    else
      turns = params['turns'].to_i
      player = Player.new(role: params['role'].to_i)
      session[:game] = Game.new(turns: turns, player: player)
    end

    redirect '/'
  end

end