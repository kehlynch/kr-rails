class Game < ApplicationRecord
  belongs_to :match
  has_many :cards, dependent: :destroy
  has_many :_announcements, -> { order(:id) }, class_name: 'Announcement', dependent: :destroy
  has_many :_bids, -> { order(:id) }, class_name: 'Bid', dependent: :destroy
  has_many :_tricks, class_name: 'Trick', dependent: :destroy
 
  has_many :game_players

  def self.deal_game(match_id, _players)
    game = Game.create(match_id: match_id)
    game_players = create_players_for(game)
    Dealer.deal(game, game_players)
    (0..11).each do |index|
      Trick.create(game_id: game.id, trick_index: index)
    end

    game.reload

    return game
  end

  def self.create_players_for(game)
    game.match.players.map do |p|
      forehand = p.position == forehand_position_for(game)
      GamePlayer.create(game: game, player: p, position: p.position, forehand: forehand)
    end
  end

  def self.forehand_position_for(game)
    game.match.earlier_games(game.id).count % 4
  end

  def self.reset!(game_id)
    Bid.where(game_id: game_id).destroy_all
    Announcement.where(game_id: game_id).destroy_all
    Card.where(game_id: game_id).each do |card|
      card.update(discard: false, trick_id: nil, played_index: nil)
      if card.talon_half
        card.update(game_player_id: nil)
      end
    end
    Game.update(king: nil, talon_picked: nil, talon_resolved: false)
    Runner.new(Game.find(game_id)).advance!
  end

  def bids
    @bids ||= Bids.new(_bids, self)
  end

  def tricks
    @tricks ||= Tricks.new(_tricks, self)
  end

  # def players
  #   @players ||= GamePlayers.new(self)
  # end

  def talon
    @talon ||= Talon.new(cards, self)
  end

  def player_teams
    @player_teams ||= PlayerTeams.new(self)
  end

  def announcements
    @announcements ||= Announcements.new(_announcements, self)
  end

  def stages
    [
      [Stage::BID, true],
      [Stage::KING, bids.pick_king?],
      [Stage::PICK_TALON, bids.talon_cards_to_pick.present?],
      [Stage::RESOLVE_TALON, bids.talon_cards_to_pick.present?],
      [Stage::ANNOUNCEMENT, bids.highest&.announcements?],
      [Stage::TRICK, true],
      [Stage::FINISHED, true]
    ].select { |_s, valid| valid }.map(&:first)
  end

  def stage
    stages.find do |stage|
      !Stage.finished?(self, stage)
    end || Stage::FINISHED
  end

  def winners
    player_teams.winners
  end

  def team_for(player)
    player_teams.team_for(player)
  end

  def make_bid!(bid_slug = nil)
    bids.make_bid!(bid_slug)
  end

  def pick_king!(king_slug)
    return if declarer_human? && !king_slug

    self.king = king_slug || declarer.pick_king

    save
  end

  def pick_talon!(talon_half_index=nil)
    if bids.talon_cards_to_pick == 6
      pick_whole_talon!
    else
      puts 'pick_talon!', declarer_human?, talon_half_index
      return if declarer_human? && talon_half_index.nil?

      talon_half_index = talon.pick_talon!(talon_half_index, declarer)

      update(talon_picked: talon_half_index)
    end
  end

  def pick_whole_talon!
    talon.pick_whole_talon!(declarer)

    # TODO: using 3 to mean all 6, since this is an int field and used to refer to the talon_half_index - sort this out!
    update(talon_picked: 3)
  end

  def resolve_talon!(putdown_card_slugs)
    return if declarer_human? && putdown_card_slugs.blank?

    talon.resolve_talon!(putdown_card_slugs, declarer)

    update(talon_resolved: true)
  end

  def play_tricks!(card_slug = nil)
    tricks.play_tricks!(card_slug)
  end

  def human_player
    players.human_player
  end

  def next_player_human?
    next_player&.human?
  end

  def next_player
    case stage
    when Stage::BID
      bids.next_bidder
    when Stage::ANNOUNCEMENT
      announcements.next_bidder
    when Stage::KING, Stage::PICK_TALON, Stage::RESOLVE_TALON
      declarer
    when Stage::TRICK
      tricks.next_player
    when Stage::FINISHED
      nil
    end
  end

  def forehand
    players.forehand
  end

  def human_forehand?
    forehand.human?
  end

  def declarer
    bids.declarer
  end

  def declarer_human?
    declarer&.human?
  end

  def partner
    player_teams.partner
  end

  def current_trick
    tricks.current_trick
  end

  def current_trick_finished?
    tricks.current_trick_finished?
  end
  
  def finished?
    tricks.finished?
  end

  def partner_known_by?(game_player_id)
    return false unless bids.finished?

    return true if partner&.id == game_player_id

    king_in_talon = talon.find { |c| c.slug == king }
    return true if king_in_talon && bids.highest.talon?

    king_played = cards.find do |c|
      c.trick_id.present? && c.slug == king
    end.present?

    return king_played
  end

  private

end
