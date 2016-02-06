require './cradle'

class Compiler
  def initialize
    @cradle = Cradle.new
    @cradle.skip_white
  end

  def assignment
    name = @cradle.get_name
    @cradle.match "="
    expression
    @cradle.emitln "MOV rbx, #{name}"
    @cradle.emitln "MOV [rbx], rax"
  end

  def expression
    if @cradle.addop? @cradle.lookup
      @cradle.emitln 'XOR rax, rax'
    else
      term
    end

    while @cradle.addop? @cradle.lookup
      @cradle.emitln 'PUSH rax'

      case @cradle.lookup
      when '+'
        add
      when '-'
        subtract
      end
    end
  end

  def add
    @cradle.match '+'
    term
    @cradle.emitln 'POP rbx'
    @cradle.emitln 'ADD rax, rbx'
  end

  def subtract
    @cradle.match '-'
    term
    @cradle.emitln 'POP rbx'
    @cradle.emitln 'SUB rax, rbx'
    @cradle.emitln 'NEG rax'
  end

  def term
    factor
    while ['/','*'].include? @cradle.lookup
      @cradle.emitln 'PUSH rax'

      case @cradle.lookup
      when '/'
        divide
      when '*'
        multiply
      end
    end
  end

  def multiply
    @cradle.match '*'
    factor
    @cradle.emitln 'POP rbx'
    @cradle.emitln 'IMUL rax, rbx'
  end

  def divide 
    @cradle.match '/'
    factor
    @cradle.emitln 'MOV rbx, rax'
    @cradle.emitln 'MOV rdx, 0'
    @cradle.emitln 'POP rax'
    @cradle.emitln 'IDIV rbx'
  end

  def factor
    if @cradle.lookup == '('
      @cradle.match '('
      expression
      @cradle.match ')'
    elsif @cradle.alpha? @cradle.lookup
      ident
    else 
      @cradle.emitln "MOV rax, #{@cradle.get_num}"
    end
  end

  def ident
    name = @cradle.get_name
    if @cradle.lookup == '('
      @cradle.match '('
      @cradle.match ')'
      @cradle.emitln "CALL #{name}"
    else
      @cradle.emitln "MOV rax, #{name}"
      @cradle.emitln "MOV rax, [rax]"
    end
  end

  def eof
    @cradle.expected "Newline" unless @cradle.eof?
  end

  class << self
    def run
      c = Compiler.new
      c.assignment
      c.eof
    end
  end
end

Compiler.run
