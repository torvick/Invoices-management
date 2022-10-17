require 'rails_helper'

RSpec.describe Emitter, type: :model do
  before(:each) do
    @attr = { :name => FFaker::NameMX.full_name,
              :rfc => FFaker::IdentificationMX.rfc
            }
  end

  it "should create a new instance given valid attributes" do
      Emitter.create!(@attr)
  end

  it "should accept valid rfcs" do
    rfcs = %w[FFaker::IdentificationMX.rfc  FFaker::IdentificationMX.rfc ]
    rfcs.each do |rfc|
      valid_rfc = Emitter.new(@attr.merge(:rfc => rfc))
      expect(valid_rfc).to be_valid
    end
  end
end
