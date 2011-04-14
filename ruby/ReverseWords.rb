# Reverse Words (Google Code Jam Africa 2010 - qualification round - problem B)
#
# Given a list of space separated words, reverse the order of the words. Each line of text contains L letters and W words.
# A line will only consist of letters and space characters. There will be exactly one space character between each pair of
# consecutive words.
#
# http://code.google.com/codejam/contest/dashboard?c=351101#s=p0

class String
  def reverseRegion!(from, to)
    half = (to - from) / 2
    (0..half).each do |i|
      self[from+i], self[to-i] = [ self[to-i], self[from+i] ]
    end
  end
end

N = gets.chop.to_i
1.upto(N).each do |c|
  sentence = gets.chop
  sentence.reverse!

  startword = 0
  while startword < sentence.size do
    endword = startword
    while !sentence[endword + 1].nil? && sentence[endword + 1] != ' ' do
      endword += 1
    end
    sentence.reverseRegion!(startword, endword)
    startword = endword + 2
  end

  puts "Case ##{c}: #{sentence}"
end
