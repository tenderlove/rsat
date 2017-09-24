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
    # Encoding scheme:
    #
    # Variables are encoded as numbers from 0 to n - 1 (n = number of variables)
    # A *non-negated* variable encoded as X is encoded as 2X.
    # Negated variables are encoded as 2X + 1
    # A `clause` is a list of encoded literals
    #
    # This lets us query variables using simple bit shifts / masks
    clause = line.split.map do |literal|
      negated  = literal.start_with?(NEGATION) ? 1 : 0
      variable = literal.sub(/^#{NEGATION}/, '')

      unless @variable_table.key? variable
        @variable_table[variable] = @variables.length
        @variables << variable
      end
      @variable_table[variable] << 1 | negated
    end

    @clauses << clause.uniq.freeze
  end

  def each_solution
    watchlist = setup_watchlist
    assignments = [:none] * variables.length
    solve watchlist, assignments, 0, false do |assignment|
      yield assignment_to_string(assignment)
    end
  end

  def setup_watchlist
    watchlist = Array.new(2 * variables.length) { [] }
    clauses.each do |clause|
      watchlist[clause.first] << clause
    end
    watchlist
  end

  def solve watchlist, assignment, d, verbose
    n = variables.length
    state = [0] * n

    loop do
      if d == n
        yield assignment
        d -= 1
        next
      end

      tried_something = false

      2.times do |a|
        if (state[d] >> a) & 1 == 0
          if verbose
            $stderr.puts "Trying #{variables[d]} = #{a}"
          end

          tried_something = true
          # Set the bit indicating a has been tried for d
          state[d] |= 1 << a
          assignment[d] = a

          if !update_watchlist(watchlist, d << 1 | a, assignment, verbose)
            assignment[d] = :none
          else
            d += 1
            break
          end
        end
      end

      if !tried_something
        if d == 0
          # Can't backtrack further. No solutions
          return
        else
          # Backtrack
          state[d] = 0
          assignment[d] = :none
          d -= 1
        end
      end
    end
  end

  def to_s
    clauses.map { |clause| clause_to_string clause }.join "\n"
  end

  private

  def update_watchlist watchlist, false_literal, assignment, verbose
    while !watchlist[false_literal].empty?
      clause = watchlist[false_literal].first
      found_alternative = false

      clause.each do |alternative|
        v = alternative >> 1
        a = alternative & 1
        if assignment[v] == :none || assignment[v] == a ^ 1
          found_alternative = true
          watchlist[false_literal].shift
          watchlist[alternative] << clause
          break
        end
      end

      unless found_alternative
        if verbose
          dump_watchlist watchlist
          $stderr.puts "Current assignment: " + assignment_to_string(assignment)
          $stderr.puts "Clause " + clause_to_string(clause) + " contradicted"
        end

        return false
      end
    end

    true
  end

  def assignment_to_string assignment
    assignment.zip(variables).map { |a, v|
      if a == 0
        "~" + v
      else
        v
      end
    }.join ' '
  end

  def dump_watchlist watchlist
    $stderr.puts "Current watchlist:"

    watchlist.each_with_index do |w, l|
      literal_string = literal_to_string l
      clauses_string = w.map { |c| clause_to_string c }.join ", "
      $stderr.puts "#{literal_string}: #{clauses_string}"
    end
  end

  def literal_to_string literal
    s = literal & 1 == 0 ? '' : NEGATION
    s + variables[literal >> 1]
  end

  def clause_to_string clause
    clause.map { |lit| literal_to_string lit }.join " "
  end
end
