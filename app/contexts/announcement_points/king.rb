module AnnouncementPoints
  class King
    def initialize(king, team:, trick:)
      @king = king
      @team = team
      @trick = trick
    end

    def points
      if @team.announced?('king')
        return -2 if [0, -1].include?(multiplier)
        return 2
      else
        return multiplier
      end
    end

    private

    def multiplier
      return 0 unless attempted?

      return 1 if @team.include?(@trick.winning_player)

      return -1
    end


    def attempted?
      return false unless @trick

      king_card_player = @trick.find_card(@king)&.player

      return false unless king_card_player

      @team.include?(king_card_player)
    end
  end
end
