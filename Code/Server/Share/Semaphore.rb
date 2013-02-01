#coding=UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__)


class Semaphore
  def initialize(p_jeton)
    raise "p_jeton < 0" if p_jeton < 0
    @read, @write = IO.pipe
    
    (1..p_jeton).each do
      v()
    end #each
  end

  def p
    @read.getc
  end
  
  def v
    @write.putc 'c'
  end
  
  def synchronize
    self.p
    begin
       yield
    ensure
       self.v
    end
  end

end


if __FILE__ == $0
    s
end
