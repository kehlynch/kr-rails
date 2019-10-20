class MessagePresenter
  attr_reader :game, :tricks, :bids

  delegate :human_declarer?, :talon_picked, to: :game
  delegate :declarer, to: :bids
  delegate :current_trick, :current_trick_finished?, :first_trick?, to: :tricks

  def initialize(game_id, stage)
    @game_id = game_id
    @stage = stage
    @game = Game.find(game_id)
    @bids = Bids.new(game_id)
    @tricks = Tricks.new(game_id)
    @msg = []
  end

  def message
    make_bid_msg if @stage == 'make_bid'

    pick_king_msg if @stage == 'pick_king'

    pick_talon_msg if @stage == 'pick_talon'

    pick_whole_talon_msg if @stage == 'pick_whole_talon'

    resolve_talon_msg if @stage == 'resolve_talon'

    resolve_whole_talon_msg if @stage == 'resolve_whole_talon'

    current_trick_finished_msg if @stage == 'next_trick'

    play_card_msg if @stage == 'play_card'

    finished_msg if @game.finished?

    @msg
  end

  private

  def declarer_name
    human_declarer? ? 'You' : PlayerPresenter.new(declarer, @game_id).name
  end

  def s_if_needed(player)
    player.human? ? '' : 's'
  end

  def winning_bid_name
    BidPresenter.new(@bids.highest&.slug).name
  end

  def make_bid_msg
    bidder = PlayerPresenter.new(@bids.next_bidder, @game_id)

    @msg = bidder.human? ? ["You are forehand."] : ["#{bidder.name} is forehand. "]

    @bids.each do |bid|
      player_presenter = PlayerPresenter.new(bid.player, @game_id)
      bid_presenter = BidPresenter.new(bid.slug)
      player_name = player_presenter.human? ? "You" : player_presenter.name
      s = s_if_needed(player_presenter)
      bid_text = bid.slug == 'pass' ? 'passes' : "bid#{s} #{bid_presenter.name}"
      @msg << "#{player_name} #{bid_text}."
    end

    @msg << "Make a bid."
  end

  def pick_king_msg
    @msg << ["#{declarer_name} declare#{s_if_needed(declarer)} #{winning_bid_name}."]
    add_declarer_bid_info

    if !human_declarer?
      @msg << "#{declarer_name} to pick talon."
      add_click_to_continue
    else 
      @msg << "Pick talon."
    end
  end

  def pick_talon_msg
    add_declared_bid_info()
    add_picked_king_info()

    if !human_declarer?
      @msg << "#{declarer_name} to pick talon."
      add_click_to_continue
    else 
      @msg << "Pick talon."
    end
  end

  def pick_whole_talon_msg
    add_declared_bid_info()
    add_picked_king_info()

    @msg << "#{declarer_name} take#{s_if_needed(declarer)} the whole talon."
    add_click_to_continue
  end

  def resolve_talon_msg
    @msg << "#{declarer_name} pick#{s_if_needed(declarer)} #{ ActiveSupport::Inflector.ordinalize(talon_picked + 1)} half of talon."
           
    return @msg << "click to continue." if !human_declarer?

    return @msg << 'pick 3 cards to put down.'
  end

  def resolve_whole_talon_msg
    @msg << "#{declarer_name} take#{s_if_needed(declarer)} the whole talon."

    add_click_to_continue if !human_declarer?

    @msg << 'pick 6 cards to put down.'
  end

  def play_card_msg
    lead = @tricks.lead_player
    lead_name = PlayerPresenter.new(lead, @game_id).name
    @msg << "#{lead_name} lead#{s_if_needed(lead)}."
    @msg << "Play a card."
  end

  def current_trick_finished_msg
    winner = current_trick.won_player
    winner_name = PlayerPresenter.new(winner, @game_id).name
    @msg << "#{winner_name} take#{s_if_needed(winner)} trick."
            
    @msg << "click to continue."
  end

  def finished_msg
    @msg << 'click for scores.'
  end

  def add_declared_bid_info
    @msg << "#{declarer_name} declare#{s_if_needed(declarer)} #{winning_bid_name}."
  end
  
  def add_click_to_continue
    @msg << "Click to continue."
  end

  def add_picked_king_info
    if @game.king
      king_name = CardPresenter.new(@game.king).name
      @msg << ["#{declarer_name} pick#{s_if_needed(declarer)} #{king_name}."]
    end
  end
end