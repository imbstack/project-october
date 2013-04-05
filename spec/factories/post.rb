FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post title ##{n}" }
    url "http://google.com"
    image_url nil
    images []
    keywords []

    user

    factory :image_post do
      image_url "http://example.com/image.jpg"
    end

    factory :post_from_url do
      images ['image1', 'image2']
      keywords [['keyword1', 5], ['keyword2', 3], ['keyword1', 2]]
    end

    factory :post_from_url_without_images do
      keywords [['keyword1', 5], ['keyword2', 3], ['keyword1', 2]]
    end

    factory :post_from_url_without_keywords do
      images ['image1', 'image2']
    end
  end
end
