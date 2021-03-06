class CalculatePaycheckService < ServiceBase
  # This service will calculate a paycheck's values based on the current
  # database records AND the paycheck's stored credits and docks. This class
  # can be used to create new paychecks, or to re-calulcate existing ones in
  # case of a change in the underlying data (a new donation, for example) or a
  # change in the checks' credits or docks.
  def initialize(paycheck:)
    super
    @paycheck = paycheck
    @employee = @paycheck.employee
    @total_shifts = paycheck.shifts
    @cv_shifts = @total_shifts.select { |s| s.fundraising_shift }
    @quota_shifts = @total_shifts.select { |s| s.quota_shift }
    @office_shifts = @total_shifts.select { |s| s.shift_type_name == "office" }
    @sick_shifts = @total_shifts.select { |s| s.shift_type_name == "sick" }
    @vacation_shifts = @total_shifts.select { |s| s.shift_type_name == "vacation" }
    @holiday_shifts = @total_shifts.select { |s| s.shift_type_name == "holiday" }
    @total_deposit = @total_shifts.map(&:total_deposit).inject(0, &:+)
    @gross_credit = @total_shifts.map(&:gross_fundraising_credit).inject(0, &:+)
    @net_credit = @gross_credit + paycheck.credits + paycheck.docks
    @total_quota = @quota_shifts.count * @employee.daily_quota
    @over_quota = @net_credit - @total_quota
    @old_buffer = get_old_buffer
    @temp_buffer = @old_buffer + @over_quota
    @bonus_credit = @temp_buffer - 500
    @bonus = (@bonus_credit > 0) ? (@bonus_credit * 0.25) : 0
    @new_buffer = (@temp_buffer > 500) ? 500 : @temp_buffer
    @total_salary = @total_shifts.count * @employee.pay_daily
    @total_pay =  @total_salary + @bonus
    @travel_reimb = @total_shifts.map(&:travel_reimb).inject(0, &:+)
  end

  def perform

    values = {
        shift_quantity:           @total_shifts.count,
        cv_shift_quantity:        @cv_shifts.count,
        quota_shift_quantity:     @quota_shifts.count,
        office_shift_quantity:    @office_shifts.count,
        sick_shift_quantity:      @sick_shifts.count,
        vacation_shift_quantity:  @vacation_shifts.count,
        holiday_shift_quantity:   @holiday_shifts.count,
        total_deposit:            @total_deposit,
        gross_fundraising_credit: @gross_credit,
        net_fundraising_credit:   @net_credit,
        total_quota:              @total_quota,
        over_quota:               @over_quota,
        old_buffer:               @old_buffer,
        temp_buffer:              @temp_buffer,
        new_buffer:               @new_buffer,
        bonus_credit:             @bonus_credit,
        bonus:                    @bonus,
        total_pay:                @total_pay,
        travel_reimb:             @travel_reimb,
        total_salary:             @total_salary
    }

    @paycheck.update_attributes(values)
  end

  private

    def get_old_buffer
      # find the new buffer from the most recent check. Since a check has
      # already been created at this point, if the employee has 1 check, its
      # their first check and old buffer should be 0. Otherwise look up the
      # last check

      paychecks = @employee.paychecks

      case paychecks.count
        when 0
          return 0
        when 1
          return 0
        else
          return paychecks.second.new_buffer
      end
    end
end
