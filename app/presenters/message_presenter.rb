class MessagePresenter
  attr_reader :game, :tricks, :bids

  delegate :winners, :talon_picked, to: :game
  delegate :declarer, to: :bids
  delegate :current_trick, :current_trick_finished?, :first_trick?, to: :tricks

  def initialize(game, stage, active_player)
    @game = game
    @stage = stage
    @game = game
    @bids = game.bids
    @tricks = game.tricks
    @active_player = active_player
    @msg = []
  end

  def message
    make_bid_msg if @stage == 'make_bid'

    make_announcement_msg if @stage == 'make_announcement'

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

  def declarer_active?
    @active_player.role == 'declarer'
  end

  def forehand_active?
    @game.forehand.id == @active_player.id
  end

  def declarer_name
    declarer_active? ? 'You' : PlayerPresenter.new(declarer, @game).name
  end

  def s_if_needed(player)
    player.id == @active_player.id ? '' : 's'
  end

  def winning_bid_name
    BidPresenter.new(@bids.highest&.slug).name
  end

  def make_bid_msg
    bidder = PlayerPresenter.new(@bids.next_bidder, @game)

    add_forehand_text

    @bids.each do |bid|
      player_presenter = PlayerPresenter.new(bid.player, @game)
      bid_presenter = BidPresenter.new(bid.slug)
      player_name = player_presenter.active? ? "You" : player_presenter.name
      s = s_if_needed(player_presenter)
      bid_text = bid.slug == 'pass' ? 'passes' : "bid#{s} #{bid_presenter.name}"
      @msg << "#{player_name} #{bid_text}."
    end

    if bidder.id == @active_player.id
      @msg << "Make a bid."
    elsif
      add_click_to_continue
    end
  end

  def pick_king_msg
    add_declared_bid_info

    if !declarer_active?
      @msg << "#{declarer_name} to pick king."
      add_click_to_continue
    else 
      @msg << "Pick a king."
    end
  end

  def pick_talon_msg
    add_declared_bid_info()
    add_picked_king_info()

    if !declarer_active?
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
    @msg << "click to continue..."
  end

  def resolve_talon_msg
    @msg << "#{declarer_name} pick#{s_if_needed(declarer)} #{ ActiveSupport::Inflector.ordinalize(talon_picked + 1)} half of talon."
           
    return @msg << "click to continue." if !declarer_active?

    return @msg << 'pick 3 cards to put down.'
  end

  def resolve_whole_talon_msg
    @msg << "#{declarer_name} take#{s_if_needed(declarer)} the whole talon."

    add_click_to_continue if !declarer_active?

    @msg << 'pick 6 cards to put down.'
  end

  def make_announcement_msg
    add_declared_bid_info
    add_picked_king_info

    player = PlayerPresenter.new(@game.announcements.next_player, @game)

    @game.announcements.each do |announcement|
      player_presenter = PlayerPresenter.new(announcement.player, @game)
      announcement_presenter = AnnouncementPresenter.new(announcement.slug)
      player_name = player_presenter.active? ? "You" : player_presenter.name
      s = s_if_needed(player_presenter)
      announcement_text = announcement.slug == 'pass' ? 'passes' : "announce#{s} #{announcement_presenter.name}"
      @msg << "#{player_name} #{announcement_text}."
    end

    if player.id == @active_player.id
      @msg << "Make an announcement."
    else
      add_click_to_continue
    end
  end

  def play_card_msg
    lead = @tricks.lead_player
    if lead.id == @active_player.id
      @msg << "You lead"
    else
      @msg << "#{lead.name} leads"
    end

    if @game.tricks.next_player.id == @active_player.id
      @msg << "Play a card."
    else
      add_click_to_continue
    end
  end

  def current_trick_finished_msg
    winner = current_trick.won_player
    winner_name = PlayerPresenter.new(winner, @game).name
    @msg << "#{winner_name} take#{s_if_needed(winner)} trick."
            
    @msg << "click to continue."
  end

  def finished_msg
    @msg << "Winners: #{winners.map { |w| player_name(w) }.join(', ')}"
  end

  def add_declared_bid_info
    @msg << "#{declarer_name} declare#{s_if_needed(declarer)} #{winning_bid_name}."
  end

  # TODO rename this
  def add_click_to_continue
    if @game.next_player_human?
      @msg << "Waiting for #{@game.next_player.name}"
    else
      @msg << "Click to continue."
    end
  end

  def add_picked_king_info
    if @game.king
      king_name = CardPresenter.new(@game.king).name
      @msg << "#{declarer_name} pick#{s_if_needed(declarer)} #{king_name}."
    end
  end

  def add_forehand_text
    if forehand_active?
      @msg << "You are forehand."
    else
      @msg << "#{player_name(@game.forehand)} is forehand."
    end
  end

  def player_name(player)
    PlayerPresenter.new(player, @game).name
  end
end
