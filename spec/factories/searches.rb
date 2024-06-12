FactoryBot.define do
  factory :search do
    query { "example query" }
    ip_address { "192.168.1.1" }
  end
end
  