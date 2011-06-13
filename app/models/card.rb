class Card < ActiveRecord::Base
  def inspect
    self.id
  end
  
  def self.find_or_create(id)
    Card.find_by_id(id) || Card.create
  end
end
