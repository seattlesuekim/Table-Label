require 'spec_helper'

describe 'Label' do
  context 'create from questions' do
    before(:all) do
      params = {}
      Label::all_foods.each do |food|
        params[food] = 'yes'
      end
      @label = Label.create_from_questions(params)
    end

    it 'returns a Label object' do
      @label.should be_a(Label)
    end

    describe '#diet_hash' do
      it 'returns a correct diet hash' do
        @label.diet_hash['sweets'].should eq 'yes'
      end
    end
  end

  context 'create from diet code' do
    before(:all) do
      @label = Label.create_from_code('abcdefgabcdefg')
    end

    it 'returns a Label object' do
      @label.should be_a(Label)
    end

    describe '#diet_hash' do
      it 'returns a correct diet hash' do
        @label.diet_hash['sweets'].should eq 'yes'
      end
    end
  end

  describe '#compress' do
    let(:orig_code) {'0120120120120120120120120120120120120120120120120120120120120120'}
    it 'compresses' do
      label = Label.new
      label.code = orig_code
      label.compress.should eq '8Wd8Wd8Wd8Wd8Wd8'
    end
  end

  describe '#decompress' do
    let(:orig_code) {')ak4w;sd'}
    it 'decompresses' do
      label = Label.new
      label.compressed_code = orig_code
      label.decompress.should eq '00002002211001022220020022022012'
    end
  end
end