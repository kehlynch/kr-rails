# frozen_string_literal: true

class Bidding

  def self.deserialize(state)
    opts = {
      contract: state['contract']&.to_sym,
      king: state['king']&.to_sym,
      talon_picked: state['talon_picked'],
      talon_resolved: state['talon_resolved'] 
    }
    Bidding.new(opts)
  end

  attr_accessor :contract, :king, :talon_picked, :talon_resolved

  def initialize(**opts)
    @contract = opts[:contract]
    @king = opts[:king]
    @talon_picked = opts[:talon_picked]
    @talon_resolved = opts[:talon_resolved]
  end

  def serialize
    {
      'contract' => @contract,
      'king' => @king,
      'talon_picked' => @talon_picked,
      'talon_resolved' => @talon_resolved
    }
  end

  def stage
    return :finished if @talon_resolved

    return :resolve_talon if @talon_picked

    return :pick_talon if @king.present?

    return :pick_king if @contract.present?

    # TODO: need to implement first level of bidding to check here
    return :pick_rufer
  end

  def finished?
    @talon_resolved
  end
end
