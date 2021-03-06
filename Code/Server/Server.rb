﻿#!/usr//bin/ruby1.9.1
#encoding: UTF-8

$LOAD_PATH << File.dirname(__FILE__)

require 'socket'
require 'Share/Semaphore'
require 'Main_Crawl'

class Server
	def initialize()
		@main_crawl = Main_Crawl.new(self)
		@sem_msg = Semaphore.new(1)

		server = TCPServer.open(PORT)
		LOG.info ("Server running on port " + PORT.to_s)
		
		# Message à la fermeture du serveur
		trap("INT") do
			shutdown()
		end
		begin
			@client = server.accept
			begin
				@wait_msg = true
				LOG.info ("New client")
				send_msg(HELLO)
				while @wait_msg
					msg = @client.gets.chomp
					receive_msg(msg)
				end # while
				@client.close
			rescue
				disconnect()
			end #begin
		end while true
		
	end #def
	
	def doc_crawled(doc)
		LOG.info ("Doc " +  doc + " crawled")
		send_msg(CRAWLDOC)
	end # def
	
	def doc_indexed(doc)
		LOG.info ("Doc " +  doc + " indexed")
		send_msg(INDEXDOC)
	end # def
	
	def error_db(msg)
		send_msg (ERRORDB + " " + msg)
	end #def
	
	def finish_compute()
		send_msg (FINISH)
	end #def
	
	private
	
	def receive_msg(msg)
		LOG.info ("Receive: " +  msg)
		args = msg.split
		
		if (args[0] == START)
			if args.size >= 5 and args.size <= 7
				host = args[1]
				user = args[2]
				password = args[3]
				database = args[4]
				nb_thread_crawl = (args.size > 5)? args[5] : NBTHREADCRAWL 
				nb_thread_index = (args.size == 7)? args[6] : NBTHREADINDEX 
				@main_crawl.run(host, user, password, database, nb_thread_crawl.to_i, nb_thread_index.to_i)
			else
				send_msg(ERRORCOMMAND + " " + START + " args : host user password database [nbThreadCrawl (default 1) nbThreadIndex (default 1)]")
			end #if
		elsif (args[0] == EXIT)
			disconnect()
		elsif (args[0] == COUNTDOC)
			nb_document()
		else
			send_msg(UNKNOWNCOMMAND)
		end #if
	end #def
	
	def nb_document()
		send_msg (NBDOC + " " + @main_crawl.nb_documents.to_s)
	end #def
	
	def send_msg(msg)
		@sem_msg.synchronize do
			@client.puts(msg)
		end #synchronize
	end # def
	
	def disconnect()
		@wait_msg = false
		LOG.info ("Client disconnected")
	end #def
	
		
	def shutdown()
		LOG.info("Server shutdown.")
		exit()
	end
end #class

# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	server = Server.new()
end #if
