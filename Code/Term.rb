#encoding: UTF-8

class Term
	attr_accessor :is_in_title, :weight, :tf, :idf
	attr_reader :label, :positions, :label_short

	def initialize(value)
		@label = value
		@label_short = value[0, 6]
		@is_in_title = false
		@positions = []
		@weight = 0
		@tf = 0.0
		@idf = 0.0
	end # def
	
	public
	
	def add_position(position)
		@positions << position if(not @positions.include?(position)) # pour éviter les doublons de position
	end #def
	
	def occurences
		return @positions.count
	end #def
	
	def weight
		return (@tf * @idf)
	end # def
	
	def ==(other)
		return other.label == @label
	end #def
end #class



if __FILE__ == $0
	test = Term.new("ploplitude")
	p test

	test.is_in_title = true
	test.add_position(1)
	test.add_position(50)

	p test
	puts test.occurences
end
