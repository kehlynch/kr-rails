module Remarks::TalonRemarks
  class TalonRemarkBase
    def initialize(game)
      @game = game
      @talon = game.talon
    end

    private

    def trump_count
      trumps.count
    end

    def trump_count_in(index)
      @talon[index].select(&:trump?).count
    end

    def highest_trump_value
      trumps.max_by(&:value)&.value || 0
    end

    def trumps
      @talon.flatten.select(&:trump?)
    end

    def total_points
      @talon.flatten.map(&:points).sum
    end

    def halves_points
      @talon.map do |half|
        half.map(&:points).sum
      end
    end

    def turned_over?
      @game.talon_cards_to_pick == 6
    end
  end
end
