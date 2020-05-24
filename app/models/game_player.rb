class GamePlayer <  ApplicationRecord
  DECLARERS = 'declarers'
  DEFENDERS = 'defenders'

  validates :team, inclusion: { in: [DECLARERS, DEFENDERS] }, allow_nil: true

  belongs_to :player
  belongs_to :game

  has_many :cards
  has_many :hand_cards, -> { where(trick_id: nil, discard: false) }, class_name: 'Card'
  has_many :original_hand_cards, -> { where(trick_half: nil) }, class_name: 'Card'


  has_many :discards, -> { where(discard: true) }, class_name: 'Card'

  has_many :announcements
  has_many :bids
  has_many :tricks

  has_many :co_players, through: :game, source: :game_players

  scope :declarers, -> { where(team: DECLARERS) }
  scope :defenders, -> { where(team: DEFENDERS) }


  def self.forehand
    find(&:forehand)
  end

  def self.next_from(game_player)
    return nil unless game_player

    find do |p|
      p.position == (game_player.position + 1) % 4
    end
  end

  def team_members
    game.game_players.where(team: team)
  end
    
  # def next_game_player
  #   @next_game_player ||= game.game_players.find do |p|
  #     p.position == (position + 1) % 4
  #   end
  # end

  def played_in_current_trick?
    return false unless game.current_trick

    cards.find { |c| c.trick_id == game.current_trick.id }.present?
  end

  def played_in_any_trick?
    cards.select(&:trick_id).any?
  end

  def won_tricks
    tricks.select { |t| t.won_player&.id == id }
  end

  def won_cards
    won_tricks.map(&:cards).flatten
  end

  def scorable_cards
    (won_cards + discards).flatten
  end

  def promised_birds
    promised_card_slugs = {
      Announcement::PAGAT => 'trump_1',
      Announcement::UHU => 'trump_2',
      Announcement::PAGAT => 'trump_3'
    }.select do |ann_slug, _card_slug|
      team_announced?(k)
    end

    hand_cards.where(slug: promised_card_slugs)
  end

  def promised_king
    return nil unless team_announced(Announcement::KING)

    hand_cards.find_by(slug: game.king)
  end

  def announced?(slug)
    announcements.find { |a| a.slug == slug }.present?
  end

  def team_announced?(slug)
    team_members.any? { |gp| gp.announced?(slug) }
  end

  def forehand?
    forehand
  end

  def trumps
    suit_cards('trump')
  end

  def suit_cards(suit)
    hand_cards.select { |c| c.suit == suit }
  end

  def declarer?
    game.declarer&.id == id
  end

  def pick_putdowns
    putdowns = []
    putdown_count = hand_cards.length - 12
    until putdowns.length == putdown_count
      putdowns << hand_cards.filter do |c|
        c.legal_putdown?(hand_cards, putdowns)
      end.sample
    end

    return putdowns
  end

  def pick_bid(valid_bids)
    BidPicker.new(bids: valid_bids, hand: hand_cards).pick
  end

  def pick_announcement(_valid_announcements)
    bird_required = game.bids.bird_required? && declarer?
    AnnouncementPicker.new(
      hand: hand_cards,
      bird_required: bird_required && !announced_bird?
    ).pick
  end

  def announced_bird?
    ['pagat', 'uhu', 'kakadu'].any? { |a| announced?(a) }
  end

  def pick_card
    return nil unless hand_cards.any?

    # TODO this needs to check if the team announced them - current just checks if this player did
    bird_announced = ['pagat', 'uhu', 'kakadu'].any? { |a| announced?(a) }
    CardPicker.new(hand: hand_cards, bird_announced: bird_announced).pick
  end

  def pick_talon
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

  # rubocop:disable Metrics/CyclomaticComplexity
  # TODO: What is this doing??? oh noooooooeee
  def init_forced_bird(number)
    slug = "trump_#{number}"
    if trick_index == (12 - number)
      @forced << slug if hand_cards.trump_legal?
    else
      trick = game.tricks.current_trick

      must_play_trump =
        trick &&
        !trick.finished? &&
        (
          trick.led_suit == 'trump' ||
          (trick.started? && !hand.cards_in_led_suit?) ||
          hand.trumps.length == hand.length
        )
      @illegal << slug unless must_play_trump && hand.trumps.length == bird_count
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def init_forced_called_king
    if trick_index == 11
      @forced << game.king if hand.called_king_legal?
    else
      @illegal << game.king unless hand.called_king_only_legal?
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
    pagat_announced? && hand_cards.include_slug?('trump_1')
  end

  def uhu?
    uhu_announced? && hand_cards.include_slug?('trump_2')
  end

  def kakadu?
    kakadu_announced? && hand_cards.include_slug('trump_3')
  end

  def pagat_announced?
    announced?(Announcement::PAGAT)
  end

  def uhu_announced?
    announced?(Announcement::UHU)
  end

  def kakadu_announced?
    announced?(Announcement::KAKADU)
  end

  def king_announced?
    announced?(Announcement::KING)
  end

  def trick_index
    game.tricks.playable_trick_index
  end
end
