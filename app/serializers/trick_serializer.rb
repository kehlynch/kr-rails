class TrickSerializer
  def initialize(trick)
    @trick = trick
  end

  def serializable_hash
    {
      finished: @trick.finished,
    }
  end

end
