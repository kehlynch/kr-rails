class GamePlayer
  attr_reader :player
  delegate :id, :human?, :position, to: :player
  def initialize(player, game)
    @player = player
    @game = game
  end

  def name
    @player.name
  end
  
  def hand
    cards = @game.cards.select do |c|
      c.player_id == id && c.trick_id.nil? && !c.discard
    end

    Hand.new(cards, @game)
  end

  def played_in_current_trick?
    return false unless @game.tricks.current_trick

    @game.tricks.current_trick.cards.map(&:player_id).include?(id)
  end

  def won_tricks
    @game.tricks.select { |t| t.won_player&.id == id }
  end

  def won_cards
    won_tricks.map(&:cards).flatten
  end

  def scorable_cards
    (won_cards + discards).flatten
  end

  def discards
    @game.cards.select { |c| c.player_id == id && c.discard }
  end

  def team
    @team ||= @game.team_for(self)
  end

  def announcements
    @game.announcements.select { |c| c.player_id == id }
  end

  def team_announcements
    team&.announcements
  end

  def bids
    @game.bids.select { |b| b.player_id == id }
  end

  def announced?(slug)
    team.announced?(slug)
  end

  def announced_individually?(slug)
    @game.announcements.any? { |a| a.player_id == id && a.slug == slug }
  end

  def defence?
    team&.defence?
  end

  def forehand?
    @player.forehand_for?(@game.id)
  end

  def trumps
    suit_cards('trump')
  end

  def suit_cards(suit)
    hand.select { |c| c.suit == suit }
  end

  def points
    Points.individual_points_for(self)
  end

  def team_points
    team&.points
  end

  def game_points
    @game.player_teams.game_points_for(self)
  end

  def declarer?
    @game.declarer == self
  end

  def winner?
    @game.winners.include?(self)
  end

  def defence?
    @game.player_teams.defence.include?(self)
  end

  def pick_putdowns
    putdowns = []
    putdown_count = hand.length - 12
    until putdowns.length == putdown_count
      putdowns << hand.filter { |c| c.legal_putdown?(hand, putdowns) }.sample
    end

    return putdowns
  end

  def pick_bid(valid_bids)
    BidPicker.new(bids: valid_bids, hand: hand).pick
  end
  
  def pick_announcements(_valid_announcements)
    bird_required = @game.bids.bird_required? && @game.bids.highest&.player_id == id
    bird_announced_by_player = ['pagat', 'uhu', 'kakadu'].any? { |a| announced_individually?(a) }
    AnnouncementPicker.new(hand: hand, bird_required: bird_required && !bird_announced_by_player).pick
  end

  def pick_card
    bird_announced = ['pagat', 'uhu', 'kakadu'].any? { |a| announced?(a) }
    CardPicker.new(hand: hand, bird_announced: bird_announced).pick
  end

  def pick_talon(_talon)
    [0, 1].sample
  end

  def pick_king
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].sample
  end

  def forced_cards
    init_forced unless @forced
    @forced
  end

  def illegal_cards
    init_forced unless @illegal
    @illegal
  end

  def init_forced
    @forced = []
    @illegal = []

    init_forced_bird(1) if pagat?
    init_forced_bird(2) if uhu?
    init_forced_bird(3) if kakadu?

    if king?
      init_forced_called_king
    end
  end
  
  def init_forced_bird(number)
    slug = "trump_#{number}"
    if trick_index == (12 - number)
      @forced << slug if hand.trump_legal?
    else
      trick = @game.tricks.current_trick
      return unless trick
      must_play_trump = trick.led_suit == 'trump' || (trick.started? && !hand.cards_in_led_suit?) || hand.trumps.length == hand.length
      @illegal << slug unless must_play_trump && hand.trumps.length == bird_count
    end
  end

  def init_forced_called_king
    if trick_index == 11
      @forced << @game.king if hand.called_king_legal?
    else
      @illegal << @game.king unless hand.called_king_only_legal?
    end
  end

  private

  def bird_count
    [pagat?, uhu?, kakadu?].filter(&:present?).length
  end

  def king?
    king_announced? && hand.called_king.present?
  end

  def pagat?
    pagat_announced? && hand.pagat.present?
  end

  def uhu?
    uhu_announced? && hand.uhu.present?
  end

  def kakadu?
    kakadu_announced? && hand.kakadu.present?
  end

  def pagat_announced?
    announced?(Announcements::PAGAT)
  end

  def uhu_announced?
    announced?(Announcements::UHU)
  end

  def kakadu_announced?
    announced?(Announcements::KAKADU)
  end

  def king_announced?
    announced?(Announcements::KING)
  end

  def trick_index
    @game.current_trick&.trick_index || 0
  end
end
