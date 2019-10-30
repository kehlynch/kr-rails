module AnnouncementPoints
  class Bird
    SLUGS = [
      'pagat',
      'uhu',
      'kakadu'
    ]


    def initialize(number, team:, tricks:)
      @number = number
      @team = team
      @tricks = tricks
      @trick = tricks[-number]
    end

    def points
      if @team.announced?(SLUGS[@number - 1])
        score = @number + 1
        return -score if [0, -1].include?(multiplier)
        return score
      else
        return multiplier
      end
    end

    private

    def multiplier
      return 0 unless attempted?

      return 1 if @trick.winning_card.slug == card_slug && @team.include?(@trick.winning_player)

      return -1
    end


    def attempted?
      return false unless @trick

      @team.include?(@trick.find_card(card_slug)&.player)
    end

    def card_slug
      "trump_#{@number}"
    end
  end
end
