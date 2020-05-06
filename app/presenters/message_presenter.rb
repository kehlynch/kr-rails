class MessagePresenter
  attr_reader :game, :tricks, :bids

  delegate :winners, :talon_picked, to: :game
  delegate :declarer, to: :bids
  delegate :current_trick, :current_trick_finished?, to: :tricks

  def initialize(game)
    @game = game
    @bids = game.bids
    @tricks = game.tricks
    @msg = []
  end

  def props
    {
      heading: @game.stage == Stage::BID ? 'Bidding' : winning_bid_name,
      king: @game.king,
      message: message
    }
  end

  def message
    msg = [forehand_msg]

    @bids.each do |bid|
      msg += bid_msg(bid)
    end

    msg += bids_finished_msg if @bids.finished?
    msg += king_picked_msg if @game.king
    msg += talon_picked_msg if talon_picked

    @game.announcements.each do |a|
      msg += announcement_msg(a)
    end
    msg += first_trick_msg if @game.announcements.finished?

    @game.tricks.each do |trick|
      msg += trick_msg(trick)
    end

    msg += finished_msg if @game.finished?

    msg
  end

  def forehand_msg
    "#{@game.forehand.name} is forehand"
  end

  def bid_msg(bid)
    bid_name = BidPresenter.new(bid.slug).name(true)
    player = bid.player
    bid_text = bid.slug == 'pass' ?  'passes' : "bids #{bid_name}"
    ["#{player.name} #{bid_text}"]
  end

  def bids_finished_msg
    msg = []
    msg << "#{declarer_name} wins bidding with #{winning_bid_name}."
    msg += next_after_bids_msg
  end

  def next_after_bids_msg
    return pick_king_msg if @bids.pick_king?
    return pick_talon_msg if @bids.talon_cards_to_pick == 3
    return pick_whole_talon_msg if @bids.talon_cards_to_pick == 6
    return first_announcement_msg if @bids.highest&.announcements?
    return first_trick_msg
  end

  def pick_king_msg
    ["#{declarer_name} to pick king."]
  end

  def king_picked_msg
    msg = []
    if @game.king
      msg << "#{declarer_name} picks #{king_name}."
      msg += next_after_king_msg
    end
    return msg
  end

  def king_name
    return unless @game.king

    OldCardPresenter.new(@game.king).name
  end

  def next_after_king_msg
    return pick_talon_msg if @bids.talon_cards_to_pick == 3
    return pick_whole_talon_msg if @bids.talon_cards_to_pick == 6
    return first_announcement_msg if @bids.highest&.announcements?
    return first_trick_msg
  end

  def talon_picked_msg
    ["#{declarer_name} picks #{ActiveSupport::Inflector.ordinalize(talon_picked + 1)} half of talon."] + first_announcement_msg
  end

  def talon_resolved_msg
    ["#{declarer_name} puts down cards"]
  end

  def first_announcement_msg
    ["#{declarer_name} starts announcements"]
  end

  def announcement_msg(announcement)
    announcement_name = AnnouncementPresenter.new(announcement.slug).name
    player = announcement.player
    announcement_text = announcement.slug == 'pass' ? 'passes' : "announces #{announcement_name}"
    ["#{player.name} #{announcement_text}"]
  end

  def first_trick_msg
    lead = @bids.lead
    return ["#{lead.name} leads first trick"]
  end

  def trick_msg(trick)
    return [] if !trick.finished?

    winner = trick.won_player
    number = ActiveSupport::Inflector.ordinalize(trick.trick_index + 1)

    ["#{winner.name} wins #{number} trick"]
  end


  def next_after_king_msg
    return pick_talon_msg if @bids.talon_cards_to_pick == 3
    return pick_whole_talon_msg if @bids.talon_cards_to_pick == 6
    return first_announcement_msg
  end

  def pick_talon_msg
    ["#{declarer_name} to pick half of talon."]
  end

  def pick_whole_talon_msg
    ["#{declarer_name} takes the whole talon."]
  end

  def finished_msg
    ["Winners: #{winners.map { |w| player_name(w) }.join(', ')}"]
  end

  def instruction_msg(player)
    game_presenter = GamePresenter.new(@game, player.id)

    p game_presenter.visible_stage

    if game_presenter.visible_stage == 'pick_king' && declarer.id != player.id
      "#{declarer_name} picks #{king_name}; click to continue."
    elsif ['pick_talon', 'pick_whole_talon', 'resolve_talon', 'resolve_whole_talon'].include?(game_presenter.visible_stage) && declarer.id != player.id
      "#{declarer_name} picks talon; click to continue."
    elsif game_presenter.show_penultimate_trick?
      "#{player_name(game_presenter.tricks[-2].won_player)} wins trick, click to continue"
    elsif game_presenter.my_move?
      active_instruction_msg(player)
    elsif game_presenter.next_player_human?
      "Waiting for #{game_presenter.next_player.name}"
    elsif game_presenter.finished?
      finished_msg.first
    else
      "Click to continue."
    end
  end

  private

  def active_instruction_msg(player)
    if current_trick && (current_trick.finished? || (!player.played_in_current_trick? && current_trick.trick_index != 0))
      return 'click for next trick'
    end

    {
      'make_bid' => 'Make a bid.',
      'pick_king' => 'Pick a king.',
      'pick_whole_talon' => 'Click to take whole talon.',
      'pick_talon' => 'Pick half of the talon.',
      'resolve_talon' => 'Pick 3 cards to put down',
      'resolve_whole_talon' => 'Pick 6 cards to put down',
      'make_announcement' => 'Make an announcement',
      'play_card' => 'Play a card'
    }[@game.stage]
  end

  def declarer_name
    PlayerPresenter.new(declarer, @game).name
  end

  def winning_bid_name
    BidPresenter.new(@bids.highest&.slug).name(true)
  end
  
  def player_name(player)
    PlayerPresenter.new(player, @game).name
  end
end
