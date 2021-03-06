# == Schema Information
#
# Table name: employees
#
#  id                                   :integer          not null, primary key
#  user_id                              :integer
#  legacy_id                            :string(255)      default("")
#  first_name                           :string(255)      default("")
#  last_name                            :string(255)      default("")
#  email                                :string(255)      default("")
#  phone                                :string(255)      default("")
#  address1                             :string(255)      default("")
#  address2                             :string(255)      default("")
#  address_city                         :string(255)      default("")
#  address_state                        :string(255)      default("")
#  address_zip                          :string(255)      default("")
#  title                                :string(255)      default("")
#  pay_hourly                           :decimal(8, 2)    default("0.0")
#  pay_daily                            :decimal(8, 2)    default("0.0")
#  hire_date                            :date
#  term_date                            :date
#  fed_filing_status                    :string(255)      default("")
#  ca_filing_status                     :string(255)      default("")
#  fed_allowances                       :integer          default("0")
#  ca_allowances                        :integer          default("0")
#  dob                                  :date
#  gender                               :string(255)      default("")
#  active                               :boolean          default("true")
#  notes                                :text             default("")
#  created_at                           :datetime
#  updated_at                           :datetime
#  daily_quota                          :decimal(8, 2)    default("0.0")
#  shifts_lifetime                      :decimal(8, 2)    default("0.0")
#  shifts_this_pay_period               :decimal(8, 2)    default("0.0")
#  shifts_this_week                     :decimal(8, 2)    default("0.0")
#  fundraising_shifts_lifetime          :decimal(8, 2)    default("0.0")
#  fundraising_shifts_this_pay_period   :decimal(8, 2)    default("0.0")
#  fundraising_shifts_this_week         :decimal(8, 2)    default("0.0")
#  donations_lifetime                   :decimal(8, 2)    default("0.0")
#  donations_this_pay_period            :decimal(8, 2)    default("0.0")
#  donations_this_week                  :decimal(8, 2)    default("0.0")
#  successful_donations_lifetime        :decimal(8, 2)    default("0.0")
#  successful_donations_this_pay_period :decimal(8, 2)    default("0.0")
#  successful_donations_this_week       :decimal(8, 2)    default("0.0")
#  raised_lifetime                      :decimal(8, 2)    default("0.0")
#  raised_this_pay_period               :decimal(8, 2)    default("0.0")
#  raised_this_week                     :decimal(8, 2)    default("0.0")
#  average_lifetime                     :decimal(8, 2)    default("0.0")
#  average_this_pay_period              :decimal(8, 2)    default("0.0")
#  average_this_week                    :decimal(8, 2)    default("0.0")
#

require 'spec_helper'

describe Employee do

  employee_attributes = SpecData.employee_attributes

  # SETUP ENVIRONMNET
  let!(:employee) { FactoryGirl.create(:employee) }

  let!(:shift_type) { FactoryGirl.create(:shift_type,
                                         fundraising_shift: true,
                                         quota_shift: true) }

  let!(:shift) { FactoryGirl.create(:shift,
                                    shift_type: shift_type,
                                    employee: employee) }

  let!(:supporter) { FactoryGirl.create(:supporter) }

  let!(:donation1) { FactoryGirl.create(:donation,
                                       shift: shift,
                                       supporter: supporter,
                                       amount: 5.0) }

  let!(:payment1) { FactoryGirl.create(:payment,
                                      donation: donation1,
                                      amount: donation1.amount,
                                      processed: true,
                                      captured: true) }

  let!(:donation2) { FactoryGirl.create(:donation,
                                        shift: shift,
                                        supporter: supporter,
                                        amount: 5.0) }

  let!(:payment2) { FactoryGirl.create(:payment,
                                       donation: donation2,
                                       amount: donation2.amount,
                                       processed: true,
                                       captured: true) }


  subject { employee }

  ## ATTRIBUTES
  describe 'employee attribute tests' do
    employee_attributes.each do |key, value|
      it { should respond_to(key)}
    end
  end

  ## RELATIONSHIPS
  it { should respond_to(:user) }
  it { should respond_to(:shifts) }
  it { should respond_to(:donations) }
  it { should respond_to(:payments) }
  it { should respond_to(:deposit_batches) }
  it { should respond_to(:paychecks) }
  
  ## VALIDATIONS
  describe 'first name validations' do
    it 'should reject employees with no first name' do
      employee.first_name = ' '
      employee.should_not be_valid
    end
    it 'should reject employees with too long first names' do
      long_name = 'a' * 26
      employee.first_name = long_name
      employee.should_not be_valid
    end
    it 'should reject employees with too short first names' do
      short_name = 'a'
      employee.first_name = short_name
      employee.should_not be_valid
    end
  end

  describe 'last name validations' do
    it 'should reject employees with no last name' do
      employee.last_name = ' '
      employee.should_not be_valid
    end
    it 'should reject employees with too long last names' do
      long_name = 'a' * 36
      employee.last_name = long_name
      employee.should_not be_valid
    end
    it 'should reject employees with too short last names' do
      short_name = 'a'
      employee.last_name = short_name
      employee.should_not be_valid
    end
  end

  describe 'email validations' do
    it 'should reject invalid emails' do
      addresses = ["user@foo,com",
                   "user_at_foo.org",
                   "example.user@foo.",
                   "foo@bar_baz.com",
                   "foo@bar+baz.com"]
      addresses.each do |invalid_address|
        employee.email = invalid_address
        employee.should_not be_valid
      end
    end
    it 'should accept valid emails' do
      addresses = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.com]
      addresses.each do |valid_address|
        employee.email = valid_address
        employee.should be_valid
      end
    end
  end

  describe 'title validation' do
    it 'should reject employees with no title' do
      employee.title = ''
      employee.should_not be_valid
    end
  end

  describe 'pay validations' do
    it 'should reject employees with both hourly and daily pay set' do
      employee.pay_hourly = 10.25
      employee.pay_daily = 100.50
      employee.should_not be_valid
    end
  #  it 'should require daily pay to be > minimum wage' do
  #    employee.pay_hourly = 10.00
  #    employee.should_not be_valid
  #  end
  end
  describe 'hire date validation' do
    it 'should reject employees without a hire date' do
      employee.hire_date = ''
      employee.should_not be_valid
    end
  end
  describe 'termination date validation' do
    it 'should be after the hire date' do
      employee.hire_date = Date.today
      employee.term_date = Date.yesterday
      employee.should_not be_valid
    end
  end
  describe 'address validations' do
    it 'should reject employees without a street address' do
      employee.address1 = ''
      employee.should_not be_valid
    end
  end
  describe 'dob validation' do
    it 'should reject employees without a dob' do
      employee.dob = ''
      employee.should_not be_valid
    end
  end
  describe 'city validation' do
    it 'should reject employees without a city' do
      employee.address_city = ''
      employee.should_not be_valid
    end
  end
  describe 'state validations' do
    it 'should reject employees without a state' do
      employee.address_state = ''
      employee.should_not be_valid
    end
    it 'should require states to be alpha' do
      employee.address_state = '4'
      employee.should_not be_valid
    end
    it 'should require states to be 2 capital letters' do
      invalid_states = %w[A AAA aa aaa A4 3 3A]
      invalid_states.each do |invalid_state|
        employee.address_state = invalid_state
        employee.should_not be_valid
      end
    end
  end
  describe 'zip validation' do
    it 'should require zip to be 5 digits' do
      bad_zips = %w[1 123 1234 123456 asbcd %$#@% ]
      bad_zips.each do |bad_zip|
        employee.address_zip = bad_zip
        employee.should_not be_valid
      end
    end
  end

  describe 'filing_status' do
    it 'should reject employees without a CA filing status' do
      employee.ca_filing_status = ''
      employee.should_not be_valid
    end
    it 'should reject employees without a fed filing status' do
      employee.fed_filing_status = ''
      employee.should_not be_valid
    end
  end

  describe 'witholding validations' do
    it 'should reject employees without a CA witholding amount' do
      employee.ca_allowances = ''
      employee.should_not be_valid
    end
    it 'should reject employees without a fed witholding amount' do
      employee.fed_allowances = ''
      employee.should_not be_valid
    end
    it 'should reject CA witholdings that are too large' do
      employee.ca_allowances = '10'
      employee.should_not be_valid
    end
    it 'should reject fed witholdings that are too large' do
      employee.fed_allowances = '10'
      employee.should_not be_valid
    end
    it 'should require CA witholdings to be integers' do
      employee.ca_allowances = 'b'
      employee.should_not be_valid
    end
    it 'should require CA witholdings to be integers' do
      employee.fed_allowances = 'b'
      employee.should_not be_valid
    end
  end

  describe 'gender validations' do
    it 'should reject employees without a gender' do
      employee.gender = ''
      employee.should_not be_valid
    end
    it 'gender should be m or f' do
      wrong_genders = %w[1 T t 34 *]
      wrong_genders.each do |wrong_gender|
        employee.gender = wrong_gender
        employee.should_not be_valid
      end
    end
  end

  describe 'phone number validations' do
    it 'should reject employees with no phone number' do
      employee.phone = ''
      employee.should_not be_valid
    end
    it 'should reject employees with an invalid phone number' do
      bad_phones = %W[1 123456789 ]
      bad_phones.each do |bad_phone|
        employee.phone = bad_phone
        employee.should_not be_valid
      end
    end
  end

end
