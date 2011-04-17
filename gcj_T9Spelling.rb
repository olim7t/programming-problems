# T9 Spelling (Google Code Jam Africa 2010 - qualification round - problem C) 
#
# The Latin alphabet contains 26 characters and telephones only have ten digits on the keypad. We would like to make it
# easier to write a message to your friend using a sequence of keypresses to indicate the desired characters. The letters
# are mapped onto the digits as shown below. To insert the character B for instance, the program would press 22. In order
# to insert two characters in sequence from the same key, the user must pause before pressing the key a second time. The
# space character ' ' should be printed to indicate a pause. For example, 2 2 indicates AA whereas 22 indicates B.
#
# For each test case, output one line containing "Case #x: " followed by the message translated into the sequence of
# keypresses.
#
# http://code.google.com/codejam/contest/dashboard?c=351101#s=p0

N = gets.chop.to_i
1.upto(N).each do |c|
  message = gets.chop

  encoded = ""
  message.chars.each do |c|
    # quick and dirty
    to_add = case c
      when 'a' then "2"
      when 'b' then "22"
      when 'c' then "222"
      when 'd' then "3"
      when 'e' then "33"
      when 'f' then "333"
      when 'g' then "4"
      when 'h' then "44"
      when 'i' then "444"
      when 'j' then "5"
      when 'k' then "55"
      when 'l' then "555"
      when 'm' then "6"
      when 'n' then "66"
      when 'o' then "666"
      when 'p' then "7"
      when 'q' then "77"
      when 'r' then "777"
      when 's' then "7777"
      when 't' then "8"
      when 'u' then "88"
      when 'v' then "888"
      when 'w' then "9"
      when 'x' then "99"
      when 'y' then "999"
      when 'z' then "9999"
      when ' ' then "0"
    end
    if !encoded.empty? && encoded[-1] == to_add[0]
      encoded.concat(" ")
    end
    encoded.concat(to_add)
  end

  puts "Case ##{c}: #{encoded}"
end
