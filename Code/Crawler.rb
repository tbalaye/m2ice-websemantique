#encoding: UTF-8
STDOUT.sync = true

require './Parse'
require './Document_parse'
require 'thread'
require './InsertDocumentDB'
require './Semaphore'


class Crawler
	attr_reader :is_running, :documents_indexed, :sem_index

	def initialize(documents, nb_thread, debug)
		raise "nb_thread must be > 0" if nb_thread < 1
		@documents_indexed = []
		@nb_thread = nb_thread
		@documents = documents
		@sem_index = Semaphore.new(0)
		@threads_crawler = []
		@is_running = false
		@debug = debug
	end #def
	
	def run()
		sem_crawl_array = Semaphore.new(1)
		@is_running = true
		# Indexer des documents
		(1..@nb_thread).each do |i|
			@threads_crawler << Thread.new do |t|
				puts "New crawling thread" if @debug
				begin
					doc = nil
					sem_crawl_array.synchronize do
						doc = @documents.pop
					end #synchronize
					
					if doc != nil
						puts "Begin crawl: "+ doc.to_s if @debug
						
						doc_tmp = Parse.new(doc).document 
						sem_crawl_array.synchronize do
							@documents_indexed << doc_tmp
							@sem_index.v
						end #synchronize
						
						puts "End crawl: "+ doc.to_s if @debug
					end #if
				end while @documents.size > 0 #begin
			end #Thread
		end #each
	end #def
	
	
	
	def stop()
		@threads_crawler.each do |t|
			t.join
		end #each
		puts "End Thread(s) crawling" if @debug
		@is_running = false
	end
	
	
	
end #class
