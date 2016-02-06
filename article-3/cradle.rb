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
      skip_white
    end
  end

  def alnum?(c)
    alpha?(c) || digit?(c)
  end

  def alpha?(c)
    ALPHABET.include? c.upcase
  end

  def digit?(c)
    DIGITS.include? c.upcase
  end

  def white?(c)
    WHITESPACE.include? c
  end

  def skip_white
    get_char while white? @lookup
  end

  def eof?
    @lookup == "\n"
  end

  def addop?(c)
    ADDOP.include? c
  end

  def get_name
    expected "Name" unless alpha? @lookup

    res = ""
    while alnum? @lookup.upcase
      res += @lookup.upcase
      get_char
    end
    skip_white

    res
  end

  def get_num
    expected "Integer" unless digit? @lookup
    res = ""
    while digit? @lookup.upcase
      res += @lookup.upcase
      get_char
    end
    skip_white

    res
  end

  def emit(s)
    print "\t#{s}"
  end

  def emitln(s)
    puts "\t#{s}"
  end
end
