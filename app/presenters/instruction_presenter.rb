class InstructionPresenter
  def initialize(message, type, trick_index=nil)
    @message = message
    @type = type
    @trick_index = trick_index
  end

  def props
    {
      instruction: @message,
      id: id
    }
  end

  private

  def id
    "js-instruction-#{@type}#{@trick_index if @trick_index}"
  end
end
