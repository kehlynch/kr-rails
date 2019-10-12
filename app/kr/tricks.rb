class Tricks
  def self.deserialize(state)
    tricks = state['tricks'].map { |t| Trick.deserialize(t) }
    Tricks.new(tricks: tricks)
  end

  def initialize(tricks: [])
    @tricks = tricks
  end

  def serialize
    {
      'tricks' => @tricks.map(&:serialize)
    }
  end

  def add_trick
    @tricks.append(Trick.new)
  end

  def [](ind)
    @tricks[ind]
  end

  def length
    @tricks.length
  end

  def finished?
    @tricks.length == 12 && @tricks[-1].finished
  end

  def started?
    !@tricks.empty?
  end
  
  def won_tricks(player_id)
    @tricks.select(&:finished).select do |t|
      t.winning_player_id == player_id
    end
  end

  def won_cards(player_id)
    @tricks
      .select { |t| t.winning_player_id == player_id }
      .map(&:cards)
      .flatten
  end
end
