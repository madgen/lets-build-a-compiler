class Cradle
  ALPHABET = ('A'..'Z')
  DIGITS = ('0'..'9')
  WHITESPACE = [" ", "\t"]
  ADDOP = ['-', '+']

  attr_reader :lookup

  def initialize
    @lookup = STDIN.getc.chr
  end

  def get_char
    @lookup = STDIN.getc.chr
  end

  def error(msg)
    STDERR.puts
    STDERR.puts "Error: #{msg}."
  end

  def abort(msg)
    error msg
    exit
  end

  def expected(item)
    abort "#{item} Expected"
  end

  def match(c)
    if c != @lookup
      expected c 
    else
      get_char 
    end
  end

  def alpha?(c)
    ALPHABET.include? c.upcase
  end

  def digit?(c)
    DIGITS.include? c.upcase
  end

  def eof?
    @lookup == "."
  end

  def addop?(c)
    ADDOP.include? c
  end

  def get_name
    expected "Name" unless alpha? @lookup

    res = @lookup.upcase
    get_char

    res
  end

  def get_num
    expected "Integer" unless digit? @lookup

    value = 0
    while digit? @lookup
      value = value * 10 + @lookup.to_i
      get_char
    end

    value
  end

  def emit(s)
    print "\t#{s}"
  end

  def emitln(s)
    puts "\t#{s}"
  end
end
