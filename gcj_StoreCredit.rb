# Store Credit (Google Code Jam Africa 2010 - qualification round - problem A) 
#
# You receive a credit C at a local store and would like to buy two items. You first walk through the store and create a
# list L of all available items. From this list you would like to buy two items that add up to the entire value of the
# credit. The solution you provide will consist of the two integers indicating the positions of the items in your list
# (smaller number first).
#
# http://code.google.com/codejam/contest/dashboard?c=351101#s=p0

case_count = gets.chop.to_i
(1..case_count).each do |c|
  credit = gets.chop.to_i
  gets # ignore item count
  item_list = gets.chop

  wanted = {}
  item_list.split(" ").each_with_index do |s, i|
    price = s.to_i
    if wanted.has_key?(price)
      puts "Case ##{c}: #{wanted[price]} #{i + 1}"
      break
    end
    wanted[credit - price] = i + 1
  end
end
