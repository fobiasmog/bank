FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name  { FFaker::Name.name }
    avatar_url { FFaker::Avatar.image }
  end
end
