require 'spec_helper'

describe PostsController do
  describe 'create action' do
    let(:the_post) { FactoryGirl.build(:post_from_url) }

    context 'with a fully-parsable post' do
      let(:valid_params) { { :post => { :title => 'Hello, this is post!', :url => 'http://example.com' } } }

      before do
        Post.stub(:new_from_url => the_post)
        sign_in :user, FactoryGirl.create(:user)
      end

      it 'saves the post' do
        post :create, valid_params
        assigns(:post).persisted?.should be_true
      end

      it 'sets the title of the post' do
        post :create, valid_params
        assigns(:post).title.should == valid_params[:post][:title]
      end
    end

    context 'when the post contains no images' do
      let(:the_post) { FactoryGirl.build(:post_from_url_without_images) }

      before do
        Post.stub(:new_from_url => the_post)
      end
    end
  end
end
