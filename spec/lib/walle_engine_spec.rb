require 'spec_helper'
require 'walle_engine'

describe WalleEngine, :current => true do
  before(:each) do
    @history = History.new
    @engine = WalleEngine.new(@history)
  end
  describe "#new" do
    
    it("should work") {@engine.should be}
    it("should have a history")  { @engine.history.should be }
    it("should have an empty set of cards"){ @engine.cards.should be_empty }
    
  end
  
  describe "#add_card" do
    
    before(:each) {@card = Card.create}
    
    it("should add the card to the set") do
      expect{@engine.add_card(@card)}.to change(@engine.cards, :length).by(1)
    end
    
    it "should initliaze the history for this card" do
      expect{@engine.add_card(@card)}.to change(@engine.history, :length).by(1)
    end
    
  end
end