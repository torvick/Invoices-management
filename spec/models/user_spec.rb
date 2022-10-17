require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @attr = { :name => FFaker::NameMX.full_name,
              :email => FFaker::Internet.email,
              :password => FFaker::Internet.password,
              :rfc => FFaker::Code.npi
            }
  end

  it "should create a new instance given valid attributes" do
      User.create!(@attr)
  end

  it "should accept valid email addresses" do
    addresses = %w[FFaker::Internet.email FFaker::Internet.email]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      expect(valid_email_user).to be_valid
    end
  end

end
