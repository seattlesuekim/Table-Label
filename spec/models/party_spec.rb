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

  let(:party) {Party.new([Label.create_from_code(')))PPED))))lQQ6,'), Label.create_from_code(')))))))))))QQQ,)')])}

  describe '#percent_hash' do
    it "doesn't insert nil into the percent hash" do
      expect(party.percent_hash.keys).to_not include(nil)
    end
  end

  describe '#arrays_by_pref' do
    it "doesn't insert any nils into the arrays by prefs" do
      party.arrays_by_pref.each do |array|
        expect(array).to_not include(nil)
      end
    end

    it 'has all the foods' do
      expect(party.arrays_by_pref.flatten.count).to eq(Label.all_foods.count)
    end
  end
end

