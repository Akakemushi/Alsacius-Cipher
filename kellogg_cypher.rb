def replace_combinations(text, replacements)
  replacements.each do |find, replace|
    text = text.gsub(find, replace)
  end
  text
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

def four_five_letter_rule(text)
  word_array = text.split(" ")
  altered_array = []
  letter_counter = 0
  toggle = true
  capital_letter_present = false
  word_array.each do |word|
    characters = word.chars
    if characters[0].match?(/[A-ZÏÙÃÑÉÆ]/)
      capital_letter_present = true
    end
    characters.each do |char|
      if char.match?(/[a-zA-ZïÏùÙãÃñÑéÉæÆ]/)
        letter_counter += 1
      end
    end
    if (letter_counter == 4 || letter_counter == 5) && toggle
      rand = rand(letter_counter + 1)
      if rand == 0 && capital_letter_present
        characters[0] = characters[0].downcase
        characters.insert(rand, "Ç")
      else
        characters.insert(rand, "ç")
      end
      new_word = characters.join
      altered_array << new_word
      letter_counter = 0
      toggle = !toggle
    elsif letter_counter == 4 || letter_counter == 5
      altered_array << word
      letter_counter = 0
      toggle = !toggle
    else
      altered_array << word
      letter_counter = 0
    end
    capital_letter_present = false
  end
  changed_string = altered_array.join(" ")
end

def scramble_rule(text)
  word_array = text.split(" ")
  altered_array = []
  letter_counter = 0
  second_letter_index = 0
  second_letter = ""
  final_letter_index = 0
  word_array.each_with_index do |word, w_index|
    if (w_index + 1) % 4 == 0
      characters = word.chars
      characters.each_with_index do |char, c_index|
        if char.match?(/[a-zA-ZïÏùÙãÃñÑéÉæÆçÇ]/)
          letter_counter += 1
          final_letter_index = c_index
          if letter_counter == 2
            second_letter_index = c_index
            second_letter = char
          end
        end
      end
      if letter_counter >= 3
        characters.insert(final_letter_index + 1, second_letter)
        characters.delete_at(second_letter_index)
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

replacements1 = {
  'th' => 'ï',
  'Th' => 'Ï',
  'ch' => 'ù',
  'Ch' => 'Ù',
  'sh' => 'ã',
  'Sh' => 'Ã',
  'ph' => 'ñ',
  'Ph' => 'Ñ',
  'ing' => 'é',
  'Ing' => 'É',
  'er' => 'æ',
  'Er' => 'Æ'
}

replacements2 = {
  'a' => 'i',
  'b' => 't',
  'c' => 'q',
  'd' => 'g',
  'e' => 'u',
  'f' => 'j',
  'g' => 'p',
  'h' => 'w',
  'i' => 'a',
  'j' => 'v',
  'k' => 'l',
  'l' => 'f',
  'm' => 'h',
  'n' => 'b',
  'o' => 'y',
  'p' => 'm',
  'q' => 'x',
  'r' => 'c',
  's' => 'r',
  't' => 'z',
  'u' => 'e',
  'v' => 's',
  'w' => 'd',
  'x' => 'k',
  'y' => 'o',
  'z' => 'n',
  'A' => 'I',
  'B' => 'T',
  'C' => 'Q',
  'D' => 'G',
  'E' => 'U',
  'F' => 'J',
  'G' => 'P',
  'H' => 'W',
  'I' => 'A',
  'J' => 'V',
  'K' => 'L',
  'L' => 'F',
  'M' => 'H',
  'N' => 'B',
  'O' => 'Y',
  'P' => 'M',
  'Q' => 'X',
  'R' => 'C',
  'S' => 'R',
  'T' => 'Z',
  'U' => 'E',
  'V' => 'S',
  'W' => 'D',
  'X' => 'K',
  'Y' => 'O',
  'Z' => 'N'
}

puts "Write your message:"
message = gets.chomp
modified_message = replace_combinations(message, replacements1)
puts modified_message
modified_message = single_pass_replace(modified_message, replacements2)
puts modified_message
modified_message = four_five_letter_rule(modified_message)
puts modified_message
modified_message = scramble_rule(modified_message)
puts modified_message
