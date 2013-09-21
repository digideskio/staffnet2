namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    employee = Employee.create!(    first_name:         'Brad',
                         last_name:          'Johnson',
                         email:              'example@example.com',
                         phone:              (0..9).to_a.shuffle.join.to_s,
                         address1:           Faker::Address.street_address,
                         address2:           Faker::Address.secondary_address,
                         city:               Faker::Address.city,
                         state:              'CA',
                         zip:                '94'+ (1..3).to_a.shuffle.join.to_s,
                         title:              'director',
                         pay_hourly:         [11.50, 12.25, 12, 13.50].sample,
                         hire_date:          Date.today,
                         fed_filing_status:  ['single', 'married'].sample,
                         ca_filing_status:   ['single', 'married'].sample,
                         fed_allowances:     [0, 1, 2, 3].sample,
                         ca_allowances:      [0, 1, 2, 3].sample,
                         dob:                Date.today - 20.years,
                         gender:             ['m', 'f'].sample,
                         active:             true )

    40.times do |n|
      employee_attributes = {   first_name:         Faker::Name.first_name,
                                last_name:          Faker::Name.last_name,
                                email:              "emp-example-#{n+1}@example.com",
                                phone:              (0..9).to_a.shuffle.join.to_s,
                                address1:           Faker::Address.street_address,
                                address2:           Faker::Address.secondary_address,
                                city:               Faker::Address.city,
                                state:              'CA',
                                zip:                '94'+ (1..3).to_a.shuffle.join.to_s,
                                title:              ['organizer', 'field_manager', 'director'].sample,
                                pay_hourly:         [11.50, 12.25, 12, 13.50].sample,
                                hire_date:          Date.today,
                                fed_filing_status:  ['single', 'married'].sample,
                                ca_filing_status:   ['single', 'married'].sample,
                                fed_allowances:     [0, 1, 2, 3].sample,
                                ca_allowances:      [0, 1, 2, 3].sample,
                                dob:                Date.today - 20.years,
                                gender:             ['m', 'f'].sample,
                                active:             [true, false].sample }

      Employee.create!(employee_attributes)
    end

    # employee should be the first employee. So create a super_admin user for it
    employee.create_user!(
                          email: employee.email,
                          role: 'super_admin',
                          password: 'foobar7878',
                          password_confirmation: 'foobar7878')


    employees = Employee.all.drop(1) #get the remaining employees and make users for them
    employees.each do |employee|
      employee.create_user!(
                            email: employee.email,
                            role: ['super_admin', 'admin', 'manager', 'staff'].sample,
                            password: 'foobar7878',
                            password_confirmation: 'foobar7878')
    end



    ## shift_types
    shift_types = ['door', 'street', 'phone', 'office', 'vacation', 'holiday', 'sick' ]
    shift_types.each do |shift_type|
      ShiftType.create!(shift_type: shift_type)
    end


  end
end