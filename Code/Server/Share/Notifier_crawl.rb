#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__) + "/../"
require 'Share/Notifier'


class Notifier_crawl < Notifier
  def update(doc)
    @server.doc_crawled(doc)
  end
end
