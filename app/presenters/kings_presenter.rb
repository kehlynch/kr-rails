class KingsPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @visible_stage = visible_stage
    @active_player = active_player
  end

  def props
    {
      visible: @visible_stage == Stage::KING,
      kings: kings_props,
      instruction: instruction,
    }
  end

  private

  def kings_props
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].map do |king_slug|
      {
        slug: king_slug,
        own_king: @active_player.declarer? && @game.declarer&.hand&.find { |c| c.slug == king_slug }.present?,
        pickable: @active_player.declarer?,
        picked: @game.king == king_slug
      }
    end
  end

  def instruction
    return "#{@game.declarer&.name} picks King of #{king_name(@game.king)}" if @game.king

    return 'pick a King' if @game.next_player.id == @active_player.id

    "waiting for #{@game.next_player.name} to pick a King"
  end

  def king_name(slug)
    "King of #{slug.split('_')[0].titleize}"
  end
end
