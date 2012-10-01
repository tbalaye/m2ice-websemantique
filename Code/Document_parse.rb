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
end #class
