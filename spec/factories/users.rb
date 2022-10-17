FactoryBot.define do
  factory :user do
    name { FFaker::NameMX.full_name }
    rfc { FFaker::IdentificationMX.rfc }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
