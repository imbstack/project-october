FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post title ##{n}" }
    url "http://google.com"
    image_file_name ""
    images []
    keywords []

    association :posted_by, :factory => :user

    factory :image_post do
      image File.new("#{Rails.root}/spec/support/images/logo1.png")
    end

    factory :post_from_url do
      images ["#{Rails.root}/spec/support/images/logo1.png", "#{Rails.root}/spec/support/images/logo2.png"]
      keywords [['keyword1', 5], ['keyword2', 3], ['keyword1', 2]]
    end

    factory :post_from_url_without_images do
      keywords [['keyword1', 5], ['keyword2', 3], ['keyword1', 2]]
    end

    factory :post_from_url_without_keywords do
      images [Rails.root + 'spec/support/images/logo1.png', Rails.root + 'spec/support/images/logo2.png']
    end
  end
end
