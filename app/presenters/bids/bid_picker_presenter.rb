class Bids::BidPickerPresenter
  def initialize(biddable_props, stage, visible)
    @biddable_props = biddable_props
    @stage = stage
    @visible = visible
  end

  def props
    {
      valid_bids: @biddable_props,
      type: @stage,
      visible: @visible
    }
  end
end
