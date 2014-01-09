class Label
  attr_accessor :code, :compressed_code

  # there are 2 levels of nesting
  FOOD_HASH = {
               'gluten' => [],
               'soy' => [],
               'corn' => [],
               'sulfite' => [],
               'garlic' => [],
               'spicy' => [],
               'acidic' => [],
               'sweets' => [],
               'yeast' => [],
               'honey' => [],
               'plant' => {'fruit' => %w(kiwi banana avocado pineapple chestnut mango/passionfruit fig/date citrus peach/apricot berry apple/pear melon cucumber tomato squash),
                       'vegetable' => %w(potato carrot legume mushroom eggplant okra),
                       'grain' => %w(wheat rice oat barley),
                       'nut' => %w(peanut tree\ nut coconut sesame\ seed)},
               'animal' => {'dairy' => %w(lactose casein whey),
                        'terrestrial' => %w(beef pork poultry egg lamb venison),
                        'marine' => %w(finned\ fish crustacean mollusc)},
               'alcohol' => %w(beer wine liquor),
  }

  def self.create_from_questions(params)
    diet = Label.new()
    diet.encode_diet(params)
    diet.compressed_code = diet.compress
    diet
  end

  def self.create_from_code(code)
    diet = Label.new()
    diet.compressed_code = code
    diet.code = diet.decompress
    diet
  end

  def self.create_array_of_labels(codes)
    label_array = []
    #split based on comma or semicolon with or without whitespace, or any number of line breaks.
    array_of_codes = codes.values[0].split(/s*[,;]\s*|\s{2,}|[\r\n]/)
    array_of_codes.each do |code|
      label_array << create_from_code(code)
    end
    label_array
  end

  def diet_hash
    @diet_hash ||= Hash[Label::all_foods.zip(decode)]
  end

  def self.all_foods
    Label.all_foods_r(FOOD_HASH)
  end
  def self.all_foods_r(s)
    array = []
    if s.is_a?(Hash)
      s.each { |k, v| array += all_foods_r(k)
                      array += all_foods_r(v) }
    elsif s.is_a?(Array)
      s.each { |i| array += all_foods_r(i) }
    # Base case
    else
      array << s.to_s
    end
    array
  end

  def encode_diet(params)
    code = ''
    params.each_pair do |k, v|
      char = if Label::all_foods.include?(k)
        if v == 'yes'
          '0'
        elsif v == 'no'
          '1'
        else
          '2'
        end
      else
        '0' # yes by default
      end
      code += char
    end
    @code = code
  end

  def decode
    values = []
    @code.each_char do |digit|
      if digit == '0'
        values << 'yes'
      elsif digit == '1'
        values << 'no'
      else
        values << 'prefer no'
      end
    end
    values
  end


  # This method converts the base-3 encoding of the questionnaire to base-81, reducing the length of the code from 64 characters
  # to 16 characters.
  def compress
    # summed array contains the decimal equivs of each group of 4 chars in base 3.
    summed_array = []
    # produce an array of groups of 4 from the preliminary code.
    # ugly way of breaking 64 chars into groups of 4
    groups_array = @code.scan(/(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)(....)/).flatten!
    # convert each group of 4 characters to decimal
    groups_array.each do |group|
      add_array = []
      offset = 0
      group.each_char do |digit|
        add_array << digit.to_i * 3 ** (3 - offset)
        offset += 1
      end
      summed_array << add_array.reduce(:+)
    end
    dec_to_81(summed_array)
  end


  # converts an array of decimal numbers to base 81
  def dec_to_81(array)
    base_81_string = ''
    array.each do |decimal|
      base_81_string += char_map[decimal]
    end
    base_81_string
  end

  # mapping from base 10 numbers to ascii chars in base 81
  def generate_map
    map = {}
    (0..81).each do |digit|
      map[digit] = (digit + ')'.ord).chr
    end
   map
  end

  def char_map
    @char_map ||= generate_map
  end

  def base_81_to_dec # convert from base 81 to base 10 using char_map
    decimal_array = []
    compressed_code.each_char do |char|
      decimal_array << char_map.key(char)
    end
    decimal_array
  end

  # this method takes the Table Label and converts it back to the base-3 code
  def decompress
    decimal_array = base_81_to_dec
    # convert array of decimals into base 3
    string = ''
    decimal_array.each do |decimal|
      dec_string = ''
      while decimal > 0
        dec_string += (decimal % 3).to_s
        decimal /= 3
      end
      if dec_string.length < 4
        dec_string += '0' * (4 - dec_string.length)
      end
      string += dec_string.reverse
    end
    string
  end
end
