require 'spec_helper'

describe PostsController do
  before do
    sign_in :user, FactoryGirl.create(:user)
  end

  describe 'create action' do
    context 'with a fully-parsable post' do
      let(:valid_params) do
        {
          :post => {
            :title => 'Hello, this is post!',
            :url => 'http://example.com',
          }
        }
      end
      let(:the_post) do
        FactoryGirl.build(:post_from_url, :url => valid_params[:post][:url])
      end

      before do
        Post.stub(:new_from_url => the_post)
      end

      it 'saves the post with the correct title, url, and image' do
        post :create, valid_params

        assigns(:post).persisted?.should be_true
        assigns(:post).title.should == valid_params[:post][:title]
        assigns(:post).url.should == valid_params[:post][:url]
        assigns(:post).image.should be_present
      end
    end

    context 'when the scraped post contains no images' do
      let(:valid_params) do
        {
          :post => {
            :title => 'Hello, this is post!',
            :url => 'http://example.com',
          }
        }
      end
      let(:the_post) do
        FactoryGirl.build(:post_from_url_without_images, :url => valid_params[:post][:url])
      end
      before do
        Post.stub(:new_from_url => the_post)
      end

      it 'persists the post' do
        post :create, valid_params
        assigns(:post).should be_persisted
      end

      it 'has a nil image attribute' do
        post :create, valid_params
        assigns(:post).image.should_not be_present
      end
    end

    context 'when the scraped post contains no keywords' do
      context 'when the user has not provided any keywords' do
        it "doesn't post the article and redirects to the new article form"
      end
      context 'when the user has provided keywords' do
        it "persists the post with the given keywords"
      end
    end

    context 'when the parsed article has no title' do
      context 'when the user has not provided a title' do
        it "doesn't post the article and redirects to the new article form"
      end
      context 'when the user has provided a title' do
        it "persists the post with the given keywords"
      end
    end
  end
end
