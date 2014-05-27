# == Schema Information
#
# Table name: deposit_batches
#
#  id         :integer          not null, primary key
#  batch_type :string(255)      default("")
#  date       :date
#  deposited  :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class DepositBatch < ActiveRecord::Base

  belongs_to :employee
  has_many :payments

  ## CALLBACKS
  after_initialize :associate_payments


  private

    def associate_payments

    end

end
