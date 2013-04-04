FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post title ##{n}" }
    url "http://google.com"
    image_url ""
    user

    factory :image_post do
      image_url "http://example.com/image.jpg"
    end
  end
end
