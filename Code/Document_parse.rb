#encoding: UTF-8
require './Paragraph'
require './Term'

class Document_parse
	attr_reader :path, :paragraphs
	attr_accessor :title
	
	def initialize(path)
		@path = path
		@paragraphs = []
		@title = ""
	end #def
	
	def add_paragraph(paragraph)
		@paragraphs << paragraph
	end
	
	def compute_idf
		n = 0.0
		ni = {}
		
		@paragraphs.each do |p|
			n += p.nb_word
			p.terms.each{|w| ni[w.label] = w.occurences}
			p.terms.each do |w|
				ni_term = (ni[w.label] != 0)? ni[w.label] : 1
				w.idf = Math.log(n/ni_term)
			end #each
		end # each
	end # def
end #class
