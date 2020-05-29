class CardPicker
  def initialize(game, game_player)
    @game = game
    @game_player = game_player
    @trick = game.current_trick
  end

  def pick
    legal_cards = LegalTrickCardService.new(@game, @game_player, @trick).legal_cards

    # TODO: stop the bots leading trumps till they're out when declarer
    if bird_announced? && legal_cards.any?(&:trump?)
      return legal_cards.select(&:trump?).sample if perc(80)
    end
    card = legal_cards.sample
    fail 'no legal card' unless card

    return card
  end

  private

  def perc(percentage)
    rand > percentage / 100
  end

  def bird_announced?
    @game.team_for(@game_player).map(&:announcements).flatten.any? do |a|
      [Announcement::PAGAT, Announcement::UHU, Announcement::KAKADU].include?(a)
    end
  end
end
