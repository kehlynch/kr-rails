class TricksPresenter
  attr_reader :tricks

  delegate(
    :[],
    :current_trick_finished?,
    :each_with_index,
    :length,
    to: :tricks
  )

  def initialize(tricks, active_player)
    @tricks = tricks
    @active_player = active_player
  end

  def props
    (0..11).map do |trick_index|
      trick = @tricks[trick_index]
      {
        index: trick_index,
        visible: @visible_trick_index == trick_index,
        cards: cards_props(trick)
      }
    end
  end

  def cards_props(trick)
    return [] unless trick

    trick.cards.map do |card|
      CardPresenter.new(card, @active_player).trick_props(trick)
    end
  end
end
