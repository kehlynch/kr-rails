module Biddable
  extend ActiveSupport::Concern
  PASS = 'pass'

  def self.started?
    !empty?
  end
end
