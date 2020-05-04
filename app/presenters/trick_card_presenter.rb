class TrickCardPresenter
  def initialize(card, trick, active_player)
    @card = card
    @trick = trick
    @active_player = active_player
  end

  def props
    {
      slug: @card.slug,
      compass: compass,
      landscape: ['east', 'west'].include?(compass),
      won: trick.won_card&.slug == @card.slug
    }
  end

  def compass
    index = (@card.player.position - active_player.position) % 4
    ['south', 'east', 'north', 'west'][index]
  end
end
