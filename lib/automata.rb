class Automata
  @@periodicity = (0..60).to_a.map{|i| rand(13)+1}
  def initialize(engine)
    @engine = engine
    @accuracy = 1.0
    @test = nil
    @iteration = 0
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
    @iteration += 1
  end
  
  def periodicity
    @@periodicity[@iteration].days
  end
  
  
end
