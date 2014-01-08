# == Schema Information
#
# Table name: donations
#
#  id            :integer          not null, primary key
#  supporter_id  :integer
#  shift_id      :integer
#  date          :date
#  donation_type :string(255)      default("")
#  source        :string(255)      default("")
#  campaign      :string(255)      default("")
#  sub_month     :string(1)        default("")
#  sub_week      :integer          default(0)
#  amount        :decimal(8, 2)    default(0.0)
#  cancelled     :boolean          default(FALSE)
#  notes         :text             default("")
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Donation do

  donation_attributes = { date: '2012/12/10', donation_type: 'Ongoing', source: 'Mail', campaign: 'Energy',
                          sub_month: 'a', sub_week: 3, amount: 10.00, cancelled: false, notes: 'Notes'}

  let(:donation) { FactoryGirl.create(:donation) }

  ## ATTRIBUTES
  describe 'donation attribute tests' do
    donation_attributes.each do |key, value|
      it { should respond_to(key)}
    end
  end

  ## RELATIONSHIPS
  it { should respond_to(:supporter) }
  it { should respond_to(:payments) }
  it { should respond_to(:shift) }
end
