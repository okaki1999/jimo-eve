FactoryBot.define do
  factory :event do
    user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    status { :published }
  end
end
