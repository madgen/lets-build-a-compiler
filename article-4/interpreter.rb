require './cradle'

class Interpreter
  def initialize
    @cradle = Cradle.new
    @table = Hash.new
    ('A'..'Z').each { |key| @table[key] = 0 }
  end

  def lookup
    @cradle.lookup
  end

  def assignment
    name = @cradle.get_name
    @cradle.match '='
    @table[name] = expression
  end

  def expression
    if @cradle.addop? @cradle.lookup 
      value = 0
    else
      value = term
    end

    while @cradle.addop? @cradle.lookup
      case @cradle.lookup
      when '+'
        @cradle.match '+'
        value += term
      when '-'
        @cradle.match '-'
        value -= term
      end
    end

    value
  end

  def term
    value = factor

    while ['*', '/'].include? @cradle.lookup
      case @cradle.lookup
      when '*'
        @cradle.match '*'
        value *= factor
      when '/'
        @cradle.match '/'
        value /= factor
      end
    end

    value
  end

  def factor
    if @cradle.lookup == '('
      @cradle.match '('
      value = expression
      @cradle.match ')'
    elsif @cradle.alpha? @cradle.lookup
      value = @table[@cradle.get_name]
    else
      value = @cradle.get_num
    end

    value
  end

  def input
    @cradle.match '?'
    @table[@cradle.get_name] = gets.chomp.to_i
  end

  def output
    @cradle.match '!'
    puts @table[@cradle.get_name]
  end

  def newline
    @cradle.match "\n"
  end

  def eof
    @cradle.expected 'Dot' unless @cradle.eof?
  end

  class << self
    def run
      i = Interpreter.new
      loop do
        case i.lookup
        when '!'
          i.output
        when '?'
          i.input
        else
          i.assignment
        end
        i.newline
        break if i.lookup == '.'
      end
      i.eof
    end
  end
end

Interpreter.run
