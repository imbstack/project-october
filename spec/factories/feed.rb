FactoryGirl.define do
  factory :feed do
    sequence(:url) { |x| "http://example.com/?feed=#{x}" }
    name "Feed Title Here!"
  end
end
