require "spec_helper"

describe Exports::DonationHistory do

  let!(:supporter) { FactoryGirl.create(:supporter) }
  let!(:donation) { FactoryGirl.create(:donation, supporter: supporter) }

  describe '::column_names' do
    it 'should return an array' do
      expect(Exports::DonationHistory.column_names).to be_an_instance_of Array
    end
  end

  describe '::supporter_fields' do
    it 'should return an array' do
      expect(Exports::DonationHistory.supporter_fields(supporter)).to \
                                                       be_an_instance_of Array
    end
  end

  describe '::donation_fields' do
    it 'should return an array' do
      expect(Exports::DonationHistory.donation_fields(donation)).to \
          be_an_instance_of Array
    end
  end

  describe 'the entire list' do
    it 'should return a StringIO' do
      result = Exports::DonationHistory.all
      expect(result).to be_an_instance_of StringIO
    end
  end

  describe 'a prospect group' do
    it 'should return a StringIO' do
      result = Exports::DonationHistory.prospect_group("a")
      expect(result).to be_an_instance_of StringIO
    end
  end
end