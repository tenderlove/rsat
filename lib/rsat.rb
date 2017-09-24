class RSAT
  VERSION = '1.0.0'
  NEGATION = "~"

  attr_reader :variables, :variable_table, :clauses

  def initialize
    @variables      = []
    @variable_table = {}
    @clauses        = []
  end

  def parse_and_add_clause line
    clause = line.split.map do |literal|
      negated  = literal.start_with?(NEGATION) ? 1 : 0
      variable = literal.sub /^#{NEGATION}/, ''

      unless @variable_table.key? variable
        @variable_table[variable] = @variables.length
        @variables << variable
      end
      @variable_table[variable] << 1 | negated
    end

    @clauses << clause.uniq.freeze
  end

  def to_s
    clauses.map { |clause| clause_to_string clause }.join "\n"
  end

  private

  def literal_to_string literal
    s = literal & 1 == 0 ? '' : NEGATION
    s + variables[literal >> 1]
  end

  def clause_to_string clause
    clause.map { |lit| literal_to_string lit }.join " "
  end
end
