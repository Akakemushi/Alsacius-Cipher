def replace_key_words(text)
  text = text.gsub("ø", "the")
  text = text.gsub("Ø", "The")
  word_array = text.split()
  altered_array = []
  letter_counter = 0
  word_array.each do |word|
    characters = word.chars
    characters.each do |char|
      if char.match?(/[a-zA-Z]/)
        letter_counter += 1
      end
    end
    if letter_counter == 1
      if word.match?(/~[a-zA-Z]~/)
        new_word = word.gsub(/~([a-zA-Z])~/, '\1')
        altered_array << new_word
        letter_counter = 0
      else
        characters.each_with_index do |char, index|
          if char.match?(/[a-m]/)
            characters[index] = "I"
          elsif char.match?(/(?<!~)[n-z](?!~)/)
            characters[index] = "a"
          elsif char.match?(/(?<!~)[N-Z](?!~)/)
            characters[index] = "A"
          end
        end
        new_word = characters.join
        altered_array << new_word
        letter_counter = 0
      end
    else
      altered_array << word
      letter_counter = 0
    end
  end
  changed_string = altered_array.join(" ")
end

def scramble_rule(text)
  word_array = text.split()
  altered_array = []
  letter_counter = 0
  second_letter_index = 0
  final_letter = ""
  final_letter_index = 0
  word_array.each_with_index do |word, w_index|
    if (w_index + 1) % 4 == 0
      characters = word.chars
      characters.each_with_index do |char, c_index|
        if char.match?(/[a-zA-ZïÏùÙãÃñÑéÉæÆçÇ]/)
          letter_counter += 1
          final_letter_index = c_index
          final_letter = char
          if letter_counter == 2
            second_letter_index = c_index
          end
        end
      end
      if letter_counter >= 3
        characters.delete_at(final_letter_index)
        characters.insert(second_letter_index, final_letter)
      end
      new_word = characters.join
      altered_array << new_word
    else
      altered_array << word
    end
    letter_counter = 0
  end
  altered_array.join(" ")
end

def four_five_letter_rule(text)
  text = text.gsub("ç", "")
  word_array = text.split()
  altered_array = []
  letter_counter = 0
  first_letter_index = 0
  second_letter_index = 0
  word_array.each do |word|
    if word.match?(/^[^Ç]*Ç[^Ç]*$/)
      characters = word.chars
        characters.each_with_index do |char, index|
          if char.match?(/[a-zA-ZïÏùÙãÃñÑéÉæÆÇ]/)
            letter_counter += 1
            if letter_counter == 1
              first_letter_index = index
            end
            if letter_counter == 2
              second_letter_index = index
            end
          end
        end
        characters[second_letter_index] = characters[second_letter_index].upcase
        characters.delete_at(first_letter_index)
        letter_counter = 0
        first_letter_index = 0
        second_letter_index = 0
        new_word = characters.join
        altered_array << new_word
    else
      altered_array << word
    end
  end
  altered_array.join(" ")
end

def single_pass_replace(text, replacements)
  letter_array = text.chars
  substituted_message = letter_array.map do |letter|
    if replacements.key?(letter)
      letter = replacements[letter]
    else
      letter
    end
  end
  changed_string = substituted_message.join
end

def replace_combinations(text, replacements)
  replacements.each do |find, replace|
    text = text.gsub(find, replace)
  end
  text
end

def replace_two_letters(text, replacements)
  word_array = text.split()
  altered_array = []
  letter_counter = 0
  word_array.each do |word|
    characters = word.chars
    characters.each do |char|
      if char.match?(/[a-zA-Z]/)
        letter_counter += 1
      end
    end
    if letter_counter == 2
      characters.each_with_index do |char, index|
        if char.match?(/[a-zA-Z]/)
          characters[index] = replacements[char]
        end
      end
      new_word = characters.join
      altered_array << new_word
      letter_counter = 0
    else
      altered_array << word
      letter_counter = 0
    end
  end
  changed_string = altered_array.join(" ")
end

replacements1 = {
  'ï' => 'th',
  'Ï' => 'Th',
  'ù' => 'ch',
  'Ù' => 'Ch',
  'ã' => 'sh',
  'Ã' => 'Sh',
  'ñ' => 'ph',
  'Ñ' => 'Ph',
  'é' => 'ing',
  'É' => 'Ing',
  'æ' => 'er',
  'Æ' => 'Er'
}

replacements2 = {
  'i' => 'a',
  't' => 'b',
  'q' => 'c',
  'g' => 'd',
  'u' => 'e',
  'j' => 'f',
  'p' => 'g',
  'w' => 'h',
  'a' => 'i',
  'v' => 'j',
  'l' => 'k',
  'f' => 'l',
  'h' => 'm',
  'b' => 'n',
  'y' => 'o',
  'm' => 'p',
  'x' => 'q',
  'c' => 'r',
  'r' => 's',
  'z' => 't',
  'e' => 'u',
  's' => 'v',
  'd' => 'w',
  'k' => 'x',
  'o' => 'y',
  'n' => 'z',
  'I' => 'A',
  'T' => 'B',
  'Q' => 'C',
  'G' => 'D',
  'U' => 'E',
  'J' => 'F',
  'P' => 'G',
  'W' => 'H',
  'A' => 'I',
  'V' => 'J',
  'L' => 'K',
  'F' => 'L',
  'H' => 'M',
  'B' => 'N',
  'Y' => 'O',
  'M' => 'P',
  'X' => 'Q',
  'C' => 'R',
  'R' => 'S',
  'Z' => 'T',
  'E' => 'U',
  'S' => 'V',
  'D' => 'W',
  'K' => 'X',
  'O' => 'Y',
  'N' => 'Z'
}

replacements3 = {
  'šcannot' => 'can\'t',
  ' šnot' => 'n\'t',
  ' šare' => '\'re',
  ' šam' => '\'m',
  ' šwill' => '\'ll',
  ' šwould' => '\'d',
  ' šhave' => '\'ve',
  'Šcannot' => 'Can\'t',
  'ŠCANNOT' => 'CAN\'T',
  ' ŠNOT' => 'N\'T',
  ' ŠARE' => '\'RE',
  ' ŠAM' => '\'M',
  ' ŠWILL' => '\'LL',
  ' ŠWOULD' => '\'D',
  ' ŠHAVE' => '\'VE'
}

puts "Write your message:"
message = gets.chomp
modified_message = scramble_rule(message)
puts ""
puts modified_message
puts ""
modified_message = four_five_letter_rule(modified_message)
puts modified_message
puts ""
modified_message = single_pass_replace(modified_message, replacements2)
puts modified_message
puts ""
modified_message = replace_combinations(modified_message, replacements1)
puts modified_message
puts ""
modified_message = replace_two_letters(modified_message, replacements2)
puts modified_message
puts ""
modified_message = replace_combinations(modified_message, replacements3)
puts modified_message
puts ""
modified_message = replace_key_words(modified_message)
puts modified_message
