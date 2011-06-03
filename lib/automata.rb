class Automata
  attr_accessor :periodicity
  def initialize(engine)
    @engine = engine
    @accuracy = 1.0
    @periodicity = 1.week
    @test = nil
  end
  
  def get_test(date)
    @test ||= @engine.generate_test(date)
  end
  
  def answer_test(date)
    answers = {}
    @test.each do |card|
      answers[card.id] = @accuracy
    end
    @test = nil
    @engine.answer_test answers, date
  end
  
  
  
end
