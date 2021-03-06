# == Schema Information
#
# Table name: sendy_updates
#
#  id               :integer          not null, primary key
#  supporter_id     :integer
#  sendy_list_id    :integer
#  sendy_batch_id   :integer
#  sendy_email      :string(255)      default("")
#  new_sendy_email  :string(255)      default("")
#  new_sendy_status :string(255)      default("")
#  action           :string(255)      default("")
#  success          :boolean          default("false")
#  completed_at     :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe SendyUpdate do

  update_attributes =  SpecData.sendy_update_attributes

  let(:sendy_update) { FactoryGirl.create(:sendy_update) }

  subject { sendy_update }

  ## RELATIONSHIPS


  ## ATTRIBUTES
  describe 'sendy update attribute tests' do
    update_attributes.each do |key, value|
      it { should respond_to(key)}
    end
  end

end
