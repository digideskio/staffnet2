class SupporterMailer < ActionMailer::Base
  default from: "Evolve Team <campaign@evolve-ca.org>"

  def receipt(supporter, donation, cim_auth_code)
    @message = ReceiptEmail.new(supporter, donation, cim_auth_code)
    mail( to:       supporter.email_1,
          from:     "Evolve Team <campaign@evolve-ca.org>",
          subject:  "Receipt and thanks!")
  end

  def pledge(supporter, employee, attributes)
    @message = PledgeEmail.new(supporter, employee, attributes)
    if supporter.email_1.present?
      mail( to:       supporter.email_1,
          from:     "Evolve Team <campaign@evolve-ca.org>",
          subject:  "Thanks for your pledge!")
    end
  end
end
