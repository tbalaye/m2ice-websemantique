#encoding: UTF-8
require './Notifier'

class Notifier_crawl < Notifier
  def update(doc)
    @server.doc_crawled(doc)
  end
end