require 'spec_helper'

describe Party do
  describe '#initialize' do
    it 'sets list_of_labels to input array' do
      labels = [Label.create_from_code('abcdefghabcdefgh'), Label.create_from_code('abcdefghabcdefgh')]
      p = Party.new(labels)
      p.list_of_labels.should eq labels
    end
  end

  describe '#set_of_leaves' do
    it 'returns the correct number of leaves' do
      Party.set_of_leaves.length.should eq 54
    end
  end
end