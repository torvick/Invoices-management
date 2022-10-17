require 'rails_helper'

RSpec.describe CodeError, type: :model do
  before(:each) do
    @attr = { :name => FFaker::NameMX.name,
              :description => FFaker::Book.description,
              :value => FFaker::Code.npi
            }
  end

  it "should create a new instance given valid attributes" do
      CodeError.create!(@attr)
  end

  it "should require a name" do
    no_name_user = CodeError.new(@attr.merge(:name => ""))
    expect(no_name_user).to be_valid
  end
end
