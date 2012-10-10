#encoding: UTF-8
STDOUT.sync = true

require './Document_parse'
require 'thread'
require './InsertDocumentDB'
require './Semaphore'

require "rubygems"
require "mysql"

class Indexer

	def initialize(crawler, nb_thread, insert, debug)
		raise "Crawler not running" if not crawler.is_running
		raise "nb_thread must be > 0" if nb_thread < 1
		@nb_thread = nb_thread
		@crawler = crawler
		@insert = insert
		@threads_indexer = []
		@debug = debug
	end #def
	
	def run()
		sem_index_array = Semaphore.new(1)
		nb_doc_indexed = 0
		
		if not @debug
			 puts "Indexing:"
			 puts "_" * 50
		end

		
		(1..@nb_thread).each do
			@threads_indexer << Thread.new do |t|
				puts "New indexing thread" if @debug
				begin
					doc = nil
					@crawler.sem_index.p
					sem_index_array.synchronize do
						doc = @crawler.documents_indexed.pop
					end #synchronize
					if doc != nil
						puts "Begin index: "+  doc.path if @debug
						@insert.compute(doc)
						
						if not @debug and 
							nb_doc_indexed += 1
							print "#" if (nb_doc_indexed.modulo(2))==0
						else
							puts "End index: "+  doc.path
						end #if
					end #if
				end while @crawler.documents_indexed.size > 0 or @crawler.is_running
			end #Thread
		end #each
	end #def
	
	def stop()
		@threads_indexer.each do |t|
			t.join
		end #each
		puts "End Thread(s) indexing" if @debug
	end #def
end #class
