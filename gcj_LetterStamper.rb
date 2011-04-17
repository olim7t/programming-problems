# Letter Stamper (Google Code Jam world finals 2010 - Problem A)
#
# Roland is a high-school math teacher. Every day, he gets hundreds of papers from his students. For each paper, he carefully chooses a letter
# grade: 'A', 'B' or 'C'. (Roland's students are too smart to get lower grades like a 'D' or an 'F'). Once the grades are all decided, Roland passes
# the papers onto his assistant - you. Your job is to stamp the correct grade onto each paper.
#
# You have a low-tech but functional letter stamp that you use for this. To print out a letter, you attach a special plate to the front of the
# stamp corresponding to that letter, dip it in ink, and then apply it to the paper.
#
# The interesting thing is that instead of removing the plate when you want to switch letters, you can just put a new plate on top of the old one.
# In fact, you can think of the plates on the letter stamp as being a stack, supporting the following operations:
# * Push a letter on to the top of the stack. (This corresponds to attaching a new plate to the front of the stamp.)
# * Pop a letter from the top of the stack. (This corresponds to removing the plate from the front of the stamp.)
# * Print the letter on the top of the stack. (This corresponds to actually using the stamp.) Of course, the stack must actually have a letter on
#   it for this to work.
#
# Given a sequence of letter grades ('A', 'B', and 'C'), how many operations do you need to print the whole sequence in order? The stack begins
# empty, and you must empty it when you are done. However, you have unlimited supplies of each kind of plate that you can use in the meantime.


# I had to look up the problem analysis to get this one right. I had started with a backtracking search with various heuristics, but it only worked
# for the simpler cases.
# It doesn't solve the large dataset in a reasonable time, I should probably rewrite it in C or Java.

class Stacks
  attr_reader :size

  def initialize(bytes)
    @elements = [ bytes[0] ]
    i = bytes.index{ |x| x != @elements[0] }
    unless i.nil?
      @elements[1] = bytes[i]
      i = bytes.index{ |x| x != @elements[0] && x != @elements[1] }
      @elements[2] = bytes[i] unless i.nil?
    end

    @element_count = @elements.size
    @total = bytes.size

    @size = @element_count == 3 ? 6 : @element_count
    if @size == 6
      @elements2 = [ @elements[0], @elements[2], @elements[1] ]
    end
  end

  def all
    0.upto(@size - 1)
  end

  # Determines which element is at position i in a well-formed stack of type s
  def [](s, i)
    if i < 1 || i > @total || s >= @size
      nil
    else
      p = (i - 1 + s) % @element_count
      target = s < 3 ? @elements : @elements2
      target[p]
    end
  end
end

T = gets.chop.to_i
1.upto(T).each do |t|
  grades = gets.chop.bytes.to_a
  n = grades.size
  stacks = Stacks.new(grades)

  if stacks.size == 1
    best = n + 2 # only one letter => trivial
  else
    # We build a search matrix with:
    #   columns (i): size of the stack
    #   rows (j): number of letters left to print
    #   each cell contains the best solution for all possible permutations of the stack

    # A row only depends on the previous row, so we only need a sliding window of two rows
    previous_row = []
    current_row = []

    # Initialize (j = 0)
    0.upto(n) do |i|
      current_row[i] = stacks.all.collect{i} # Trivial case: if nothing more to print, pop the stack
      previous_row[i] = []
    end


    worst = 3 * n # worst possible score (push & print all, pop all)

    1.upto(n) do |j|
      previous_row, current_row = [current_row, previous_row]

      to_print = grades[-j]

      0.upto(n) do |i|
        stacks.all.each do |s|
          on_top = stacks[s, i]
          can_push = stacks[s, i + 1]
          current_row[i][s] =
            if to_print == on_top
              previous_row[i][s] + 1
            else
              pop = if i == 0
                      worst
                    elsif i == 1
                      # When we empty the stack, we can switch to any other sequence
                      stacks.all.collect{ |x| current_row[0][x] }.min + 1
                    elsif i == 2 && stacks.size == 6
                      # two possible sequences
                      [s, (s + 3) % stacks.size].collect{ |x| current_row[1][x] }.min + 1
                    else
                      current_row[i - 1][s] + 1
                    end
              if to_print == can_push
                [ previous_row[i + 1][s] + 2, # push & print
                  pop ].min
              else
                pop
              end
            end
        end
      end

      # uncomment to print the search matrix
      #puts previous_row.collect{|c| c.join ","}.join " | " if j == 1
      #puts current_row.collect{|c| c.join ","}.join " | "

    end

    best = worst
    current_row.each_with_index do |c, i|
      best_stack = c.min
      best_stack += i # if we start with a non-empty stack, we need to build it first
      best = [ best, best_stack ].min
    end
  end
  puts "Case ##{t}: #{best}"
end
