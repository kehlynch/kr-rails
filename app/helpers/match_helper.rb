module MatchHelper
  def match_points(match_games)
    points = match_games.map do |game|
      if game.finished?
        game.players.map do |p|
          points = p.game_points
        end
      else
        []
      end
    end

    acc_points = points.each_with_index.map do |game_points, game_index|
        game_points.each_with_index.map do |p, player_index|
          points[0..game_index].map { |p| p[player_index] }.sum
        end
      end

    acc_points
  end

  def bid_shorthand(game)
    winning_bid = game.bids.highest
    BidPresenter.new(winning_bid.slug).shorthand
  end

  def points_classes(player, game)
    forehand_class = game.forehand.id == player.id ? 'forehand' : ''
    winner_class = game.winners.map(&:id).include?(player.id) ? 'winner' : ''
    declarer_class = game.declarer.id == player.id ? 'declarer' : ''
    
    [forehand_class, winner_class, declarer_class].join(' ')
  end

  def bid_classes(game)
    'off' if !game.winners.include?(game.declarer)
  end

  def announcement_shorthands(game)
    entries = Announcements::SLUGS.map do |slug|
      announcement_entries(game, slug)
    end

    content_tag(:div, class: 'announcements') do
      entries.reject { |e| e == [] }.flatten(1).collect do |shorthand, classes|
        concat(content_tag(:span, shorthand, class: classes.join(' ')))
      end
    end
  end

  def announcement_entries(game, slug)
    entries = []
    game.player_teams.each do |team|
      if team.made_announcement?(slug) || team.lost_announcement?(slug)
        entries << announcement_entry(team, slug)
      end
    end
    return entries
  end

  def announcement_entry(team, slug)
    classes = announcement_classes(team, slug)
    shorthand = AnnouncementPresenter.new(slug).shorthand
    # {shorthand: shorthand, classes: classes}
    # content_tag(:span, shorthand, class: classes.join(' '))
    [shorthand, classes]
  end

  def announcement_classes(team, slug)
    classes = []
    classes << 'off' if team.lost_announcement?(slug)
    classes << 'defence' if team.defence?
    classes << 'declared' if team.announced?(slug)
    return classes
  end
end