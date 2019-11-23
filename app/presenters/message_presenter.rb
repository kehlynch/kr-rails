class MessagePresenter
  attr_reader :game, :tricks, :bids

  delegate :winners, :talon_picked, to: :game
  delegate :declarer, to: :bids
  delegate :current_trick, :current_trick_finished?, :first_trick?, to: :tricks

  def initialize(game, active_player)
    @game = game
    @bids = game.bids
    @tricks = game.tricks
    @active_player = PlayerPresenter.new(active_player, game)
    @msg = []
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
    forehand_active? ? 'You are forehand.' : "#{@game.forehand.name} is forehand"
  end

  def bid_msg(bid)
    bid_name = BidPresenter.new(bid.slug).name(true)
    player = bid.player
    active = player.id == @active_player.id
    player_name = active ? "You" : player.name
    bid_text = if bid.slug == 'pass'
             active ? 'pass' : 'passes'
           else
             active ? "bid #{bid_name}" : "bids #{bid_name}"
           end
    ["#{player_name} #{bid_text}"]
  end

  def bids_finished_msg
    msg = []
    msg << "#{declarer_name} win#{s_if_needed(declarer)} bidding with #{winning_bid_name}."
    msg << next_after_bids_msg
  end

  def next_after_bids_msg
    return pick_king_msg if @bids.pick_king?
    return pick_talon_msg if @bids.talon_cards_to_pick == 3
    return pick_whole_talon_msg if @bids.talon_cards_to_pick == 6
    return first_announcement_msg
  end

  def pick_king_msg
    "#{declarer_name} to pick king."
  end

  def king_picked_msg
    msg = []
    if @game.king
      king_name = CardPresenter.new(@game.king).name
      msg << "#{declarer_name} pick#{s_if_needed(declarer)} #{king_name}."
      msg += next_after_king_msg
    end
    return msg
  end

  def next_after_king_msg
    return pick_talon_msg if @bids.talon_cards_to_pick == 3
    return pick_whole_talon_msg if @bids.talon_cards_to_pick == 6
    return first_announcement_msg
  end

  def talon_picked_msg
    ["#{declarer_name} pick#{s_if_needed(declarer)} #{ActiveSupport::Inflector.ordinalize(talon_picked + 1)} half of talon."]
  end

  def first_announcement_msg
    ["#{declarer_name} start#{s_if_needed(declarer)} announcements"]
  end

  def announcement_msg(announcement)
    announcement_name = AnnouncementPresenter.new(announcement.slug).name
    player = announcement.player
    active = player.id == @active_player.id
    player_name = active ? "You" : player.name
    announcement_text = if announcement.slug == 'pass'
             active ? 'pass' : 'passes'
           else
             active ? "announcement #{announcement_name}" : "announcements #{announcement_name}"
           end
    ["#{player_name} #{announcement_text}"]
  end

  def first_trick_msg
    lead = @tricks.lead_player
    return ["You lead first trick"] if lead.id == @active_player.id

    return ["#{lead.name} leads first trick"]
  end

  def trick_msg(trick)
    return [] if !trick.finished?

    winner = trick.won_player
    number = ActiveSupport::Inflector.ordinalize(trick.trick_index + 1)
    return ["You win #{number} trick"] if winner.id == @active_player.id

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
    ["#{declarer_name} take#{s_if_needed(declarer)} the whole talon."]
  end

  def finished_msg
    ["Winners: #{winners.map { |w| player_name(w) }.join(', ')}"]
  end

  def instruction_msg
    if @game.next_player&.id == @active_player.id
      return active_instruction_msg
    elsif @game.next_player_human?
      return "Waiting for #{@game.next_player.name}"
    else
      return "Click to continue."
    end
  end

  private

  def active_instruction_msg
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
    BidPresenter.new(@bids.highest&.slug).name(true)
  end
  
  def player_name(player)
    PlayerPresenter.new(player, @game).name
  end
end
