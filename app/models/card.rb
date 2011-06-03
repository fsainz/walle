class Card < ActiveRecord::Base
  def inspect
    self.id
  end
end
