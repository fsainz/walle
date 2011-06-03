module WalleEngine

  class WalleEngine
    #  include WalleOne
    #  include WalleRandom

    attr_accessor :history, :cards
    def initialize(history)
      @history = history
      @cards = []
    end
  
    def add_card(card)
      @cards << card
    end
  
    def answer_test(answers, date)
      answered_cards = []
      answers.each do |card_id, quality|
        answered_cards << card_id
        new_strength = new_card_strength(card_id, quality)
        @history.update_card(card_id, date, quality, new_strength)
      end
      not_answered_cards = @cards.map(&:id) - answered_cards
    
      not_answered_cards.each do |card_id|
        @history.update_card(card_id, date, -1.0, @history.card_strength(card_id))
      end
    end
  
    def to_yaml
      {:cards => @cards.map(&:id).join(", "),
        :history => @history
      }.to_yaml
    end
  
    def inspect
      "engine.inspect"
    end
  
  end




  class WalleOne < WalleEngine
    def generate_test(date, size=5)
      settling_period = 1.week
      retentions_if_reviewed, retentions_if_not_reviewed = caclulate_potential_retentions(settling_period)
      rets = Hash.new()
      @cards.map(&:id).combination(5).to_a.each do |chosen_cards|
        avg = average_retentions(chosen_cards, retentions_if_reviewed, retentions_if_not_reviewed).to_i
        best_retention_so_far = rets.sort.first.try(:first) || 0
        if avg.to_i > best_retention_so_far 
          if rets[avg] 
            rets[avg] << chosen_cards
          else 
            rets[avg] = [chosen_cards]
          end
        end
      end
      Card.find(rets.sort.first[1].first)
    end
  
    def new_card_strength(card_id, quality)
      @history.card_strength(card_id) * 2
    end
  
  
  
    def caclulate_potential_retentions(settling_period)
      retentions_if_reviewed = Hash.new
      retentions_if_not_reviewed = Hash.new
    
      @cards.each do |card|
        retentions_if_not_reviewed[card.id] = @history.card_retention_in(card.id, settling_period)
        retentions_if_reviewed[card.id] = @history.expected_card_retention(settling_period, new_card_strength(card.id, nil))
      end 
      return retentions_if_reviewed, retentions_if_not_reviewed
    end
    
    def average_retentions(chosen_cards, retentions_if_reviewed, retentions_if_not_reviewed)
      rets = []
      not_chosen_cards = @cards.map(&:id) - chosen_cards
      chosen_cards.each do |card|
        rets << retentions_if_reviewed[card]
      end
      not_chosen_cards.each do |card|
        rets << retentions_if_not_reviewed[card]
      end
      rets.sum/rets.length.to_f
    end
  
  
  end


  class WalleRandom < WalleEngine
    def generate_test(date,size=5)
      @cards.shuffle[0..size-1]
    end
  
    def new_card_strength(card_id, quality)
      @history.card_strength(card_id) * 2
    end
  end

end