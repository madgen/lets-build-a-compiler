require './cradle'

class Expression
  def initialize
    @cradle = Cradle.new
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
      else 
        @cradle.expected 'AddOp'
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
      else
        @cradle.expected 'MulOp'
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
    else
      @cradle.emitln "MOV rax, #{@cradle.get_num}"
    end
  end
end

exp = Expression.new
exp.expression
