require 'set'

class Party
  attr_accessor :list_of_labels

  def initialize(labels)
    @list_of_labels = labels
  end

  def self.set_of_leaves
    @set_of_leaves ||= set_of_leaves_r(Label::FOOD_HASH)
  end

  def self.set_of_leaves_r(root)
    s = Set.new
    if root.is_a?(Hash)
      root.each_pair do |k, v|
        if v.is_a?(String)
          s << v
        elsif v == []
          s << k
        else
          s.merge(set_of_leaves_r(v))
        end
      end
    elsif root.is_a?(Array)
      root.each do |v|
        s << v
      end
    end
    s
  end

  # generates a hash containing the proportion of people okay with a certain food.
  def make_percent_hash
    label_count = @list_of_labels.count
    @percent_hash = Hash.new(0)
    @list_of_labels.each do |label|
      label.diet_hash.each_pair do |k, v|
        if v == 'yes'
          @percent_hash[k] += 100/label_count
        elsif v == 'prefer no'
          @percent_hash[k] += 25/label_count
        else
          @percent_hash[k] += 0
        end
      end
    end
    @percent_hash
  end

  def percent_hash
    @percent_hash ||= make_percent_hash
  end

  # the A-list is 100% yes
  # the B-list is 80-100%
  # the C-list is 60-80%
  # the F-list is 0-60%
  def arrays_by_pref
    list_of_pref_arrays = []
    a_list = []
    b_list = []
    c_list = []
    f_list = []
    percent_hash.each_pair do |k, v|
      if v >= 98 && v <= 100
        a_list << k
      elsif v >= 80 && v < 100
        b_list << k
      elsif v >= 60 && v < 80
        c_list << k
      else
        f_list << k
      end
    end
    list_of_pref_arrays << a_list << b_list << c_list << f_list
    list_of_pref_arrays
  end

end
