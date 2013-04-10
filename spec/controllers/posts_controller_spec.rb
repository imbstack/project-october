require 'spec_helper'

describe PostsController do
  before do
    sign_in :user, FactoryGirl.create(:user)
    Post.any_instance.stub(:set_image_if_necessary => 'noop')
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

      it 'saves the post with the correct title and url' do
        post :create, valid_params

        assigns(:post).persisted?.should be_true
        assigns(:post).title.should == valid_params[:post][:title]
        assigns(:post).url.should == valid_params[:post][:url]
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

    context 'when the user has not provided any keywords' do
      let(:keywordless_params) do
        {
          :post => {
            :title => 'Hello, this is post!',
            :url => 'http://example.com',
          }
        }
      end

      let(:the_post) do
        FactoryGirl.build(:post_from_url_without_keywords, :url => keywordless_params[:post][:url])
      end

      before do
        Post.stub(:new_from_url => the_post)
      end

      it "doesn't post the article and redirects to the new article form" do
        post :create, keywordless_params

        assigns(:post).should_not be_persisted
        response.should redirect_to new_post_path
      end
    end

    context 'when the user has provided keywords' do
      let(:keyworded_params) do
        {
          :post => {
            :title => 'Hello, this is post!',
            :url => 'http://example.com',
            :keywords => ['keyword1', 'keyword2'],
          }
        }
      end

      let(:the_post) do
        FactoryGirl.build(:post_from_url_without_keywords, :url => keyworded_params[:post][:url])
      end

      before do
        Post.stub(:new_from_url => the_post)
      end

      it "persists the post with the given keywords" do
        post :create, keyworded_params

        assigns(:post).should be_persisted
      end
    end

    context 'when the parsed article has no title' do
      let(:the_post) do
        FactoryGirl.build(:post_from_url_without_title, :url => title_params[:post][:url])
      end

      context 'when the user has not provided a title' do
        let(:title_params) do
          {
            :post => {
              :url => 'http://example.com',
              :keywords => ['keyword1', 'keyword2'],
            }
          }
        end

        before do
          Post.stub(:new_from_url => the_post)
        end

        it "doesn't post the article and redirects to the new article form" do
          post :create, title_params

          assigns(:post).should_not be_persisted
          response.should redirect_to new_post_path
        end
      end

      context 'when the user has provided a title' do
        let(:title_params) do
          {
            :post => {
              :title => 'This is the article title!',
              :url => 'http://example.com',
              :keywords => ['keyword1', 'keyword2'],
            }
          }
        end

        before do
          Post.stub(:new_from_url => the_post)
        end

        it "persists the post with the given keywords" do
          post :create, title_params

          assigns(:post).should be_persisted
        end
      end
    end
  end
end
