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
      @history.update_retentions_before_review(date)
      
      answered_cards = []
      answers.each do |card_id, quality|
        answered_cards << card_id
        new_strength = new_card_strength(card_id, quality, date)
        @history.update_card(card_id, date, quality, new_strength)
      end
      not_answered_cards = @cards.map(&:id) - answered_cards
    
      not_answered_cards.each do |card_id|
        @history.update_card(card_id, date, -1.0, @history.card_strength(card_id))
      end
      
      @history.update_healthy_cards_record
      @history.update_retention_status
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
    def settling_period
#      @history.cards_strengths.sort[0..4].average
      1.day
    end
    
    def generate_test(date, size=5)
      retentions_if_reviewed, retentions_if_not_reviewed = caclulate_potential_retentions(settling_period, date)
      rets = Hash.new()
      @cards.map(&:id).combination(size).to_a.each do |chosen_cards|
        avg = average_retentions(chosen_cards, retentions_if_reviewed, retentions_if_not_reviewed)
        rets[avg] = chosen_cards
      end
      Card.find(rets.sort.last[1])
    end
  
    def new_card_strength(card_id, quality, date_of_review=nil)
      @history.card_strength(card_id) * ( 1 + ajuste_del_incremento(card_id, date_of_review))
    end
  
    def ajuste_del_incremento(card_id, review_date)
      opt_date = @history.optimal_date_of_review(card_id)
      last_review_date = @history.card_last_update(card_id)
      
      return 1 if review_date > opt_date
      delta = (review_date - last_review_date).to_f / (opt_date - last_review_date)
      
      if delta < 0
        raise StandardError, {:error => "delta es negativo", :last_rvw => last_review_date, :rvw => review_date, :opt => opt_date}.inspect
      end
      
      if (opt_date - last_review_date) < 0
        raise StandardError, {:error => "opt_date esta antes que last_review_date", :last_rvw => last_review_date, :rvw => review_date, :opt => opt_date}.inspect
      end
      
      delta
    end
  
  
    def caclulate_potential_retentions(settling_period, date)
      retentions_if_reviewed = Hash.new
      retentions_if_not_reviewed = Hash.new
    
      @cards.each do |card|
        retentions_if_not_reviewed[card.id] = @history.card_retention_in(card.id, settling_period)
        retentions_if_reviewed[card.id] = @history.expected_card_retention(settling_period, new_card_strength(card.id, nil, date))
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
      #      if @debug
      #        pp "......"
      #        pp rets
      #        @debug = false
      #      end
      rets.average
    end
  
  
  end


  class WalleRandom < WalleEngine
    def generate_test(date,size=5)
      @cards.shuffle[0..size-1]
    end
  
    def new_card_strength(card_id, quality, date)
      @history.card_strength(card_id) * 2
    end
  end

  class WalleOneRandom < WalleOne
    def generate_test(date,size=5)
      @cards.shuffle[0..size-1]
    end
  end

  class WalleOneComa5 < WalleOne
    def settling_period
      @settling ||= 11
      @settling = @settling - 1
    end
  end

  require 'pp'
  
  class WalleTwo < WalleOne
    def settling_period
      1.month
    end
    
    def generate_test(date,size=5)
      expired_cards = []
      healthy_cards = []
      chosen_cards = []
      
      @cards.each do |card|
        ret = @history.card_retention_in(card.id, 0.day)
        if ret > 50
          healthy_cards << card
        else
          expired_cards << [ret, card]
        end
      end
      debugger
      
      chosen_cards = expired_cards.sort{|a,b|a[0] <=> b[0]}.map {|a| a[1]}[0..size-1]
      return chosen_cards if chosen_cards.length == size
      
      retentions_if_reviewed, retentions_if_not_reviewed = caclulate_potential_retentions(settling_period, date)
      rets = Hash.new()
      num_pend_cards = size - chosen_cards.length #este es el numero de tarjetas que faltan para construir un test
                                                  #depende del numero de tarjetas que hubiera con R < 0.5
      healthy_cards.map(&:id).combination(num_pend_cards).to_a.each do |chosen_cards2|
        avg = average_retentions(chosen_cards2, retentions_if_reviewed, retentions_if_not_reviewed)
        rets[avg] = chosen_cards2
      end
      chosen_cards << Card.find(rets.sort.last[1])
      chosen_cards.flatten
    end
  end
  
  
  

end