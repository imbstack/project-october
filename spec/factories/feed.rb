FactoryGirl.define do
  factory :feed do
    sequence(:url) { |x| "http://example.com/?feed=#{x}" }
    sequence(:name) { |x| "Feed Title ##{x} Here!" }
  end
end
