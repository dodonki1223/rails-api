FactoryBot.define do
  factory :comment do
    content { "MyText" }
    artile { nil }
    user { "MyString" }
    references { "MyString" }
  end
end
