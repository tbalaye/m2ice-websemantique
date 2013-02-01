#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)
require 'Notifier'

class Notifier_index < Notifier
  def update(doc)
    @server.doc_indexed(doc)
  end
end
