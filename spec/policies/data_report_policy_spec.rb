require 'spec_helper'

describe DataReportPolicy do
  subject { DataReportPolicy.new(user, data_report) }

  let(:data_report) { DataReport.new }

  context 'for a regular user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should_not permit(:new) }
    #it { should_not permit(:show) }
    #it { should_not permit(:index) }
    #it { should_not permit(:update) }
    #it { should_not permit(:edit) }
  end

  context 'for a staff user' do
    let(:user) { FactoryGirl.create(:staff) }

    it { should_not permit(:new) }
    #it { should_not permit(:show) }
    #it { should_not permit(:index) }
    #it { should_not permit(:update) }
    #it { should_not permit(:edit) }
  end

  context 'for a manager user' do
    let(:user) { FactoryGirl.create(:manager) }

    it { should_not permit(:new) }
    #it { should_not permit(:show) }
    #it { should_not permit(:index) }
    #it { should_not permit(:update) }
    #it { should_not permit(:edit) }
  end

  context 'for an admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    
    it { should permit(:new) }
    #it { should permit(:show) }
    #it { should permit(:index) }
    #it { should permit(:update) }
    #it { should permit(:edit) }
  end

  context 'for a super_admin user' do
    let(:user) { FactoryGirl.create(:super_admin) }

    it { should permit(:new) }
    #it { should permit(:show) }
    #it { should permit(:index) }
    #it { should permit(:update) }
    #it { should permit(:edit) }
  end
end
