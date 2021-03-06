class Points::AnnouncementScoresService
  POINTS = {
    Announcement::PAGAT => [2, 1],
    Announcement::UHU => [3, 1],
    Announcement::KAKADU => [4, 1],
    Announcement::KING => [2, 1],
    Announcement::FORTY_FIVE => [2, 0],
    Announcement::VALAT => [8, 4]
  }

  def initialize(game, team, team_name)
    @game = game
    @team = team
    @team_name = team_name
  end

  def create_announcement_scores
    {
      Announcement::PAGAT => bird_status(1),
      Announcement::UHU => bird_status(2),
      Announcement::KAKADU => bird_status(3),
      Announcement::KING => king_status,
      Announcement::FORTY_FIVE => forty_five_status,
      Announcement::VALAT => valat_status,
    }.each do |slug, status|
      a = team_announcement(slug)
      p [slug, status]
      case status
      when :not_attempted
        next unless a.present?

        maybe_create_announcement_score(slug, a, off: true)
      when :succeeded
        maybe_create_announcement_score(slug, a, off: false)
      when :failed
        maybe_create_announcement_score(slug, a, off: true)
      end
    end
  end

  private

  def maybe_create_announcement_score(slug, announcement, off:)
    kontra = announcement&.kontra || 1
    declared = announcement.present?
    absolute_points = declared ? declared_points(slug) * kontra : undeclared_points(slug)

    return unless absolute_points != 0

    points = off ? -absolute_points : absolute_points

    @game.announcement_scores.create(
      slug: slug,
      kontra: kontra,
      off: off,
      declared: declared,
      team: @team_name,
      points: points
    )
  end

  def declared_points(slug)
    POINTS[slug][0]
  end

  def undeclared_points(slug)
    POINTS[slug][1]
  end

  def team_announcement(slug)
    @team.map(&:announcements).flatten.find { |a| a.slug == slug }
  end

  def bird_status(number)
    slug = "trump_#{number}"
    trick_index = 12 - number
    card_played_on_trick_status(slug, trick_index, true)
  end

  def king_status
    card_played_on_trick_status(@game.king, 11)
  end

  def card_played_on_trick_status(slug, trick_index, card_must_win=false)
    trick = @game.tricks
      .find { |t| t.trick_index == trick_index }

    played_in_trick = trick.cards.find { |c|  c.slug == slug }.present?
    team_played_card = @team.map(&:cards).flatten.find { |c| c.slug == slug }.present?

    return :not_attempted unless played_in_trick && team_played_card


    if card_must_win
      card_won_trick = trick.won_card.slug == slug
      return :succeeded if card_won_trick
    else
      team_won_trick = @team.map(&:won_tricks).flatten.find { |t| t.trick_index == trick_index }.present?
      return :succeeded if team_won_trick
    end

    return :failed
  end

  def forty_five_status
    @team.map(&:card_points).sum >= 45 ? :succeeded : :not_attempted
  end

  def valat_status
    @team.map(&:won_tricks).flatten.size == 12 ? :succeeded : :not_attempted
  end
end
