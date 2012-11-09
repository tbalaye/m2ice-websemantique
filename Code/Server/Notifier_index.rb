#encoding: UTF-8
require './Notifier'

class Notifier_index < Notifier
  def update(doc)
    @server.doc_indexed(doc)
  end
end