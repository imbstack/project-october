require 'spec_helper'

describe Post do
  describe '.new_from_url' do
    let(:keywords) { [['keyword1', 3], ['keyword2', 2]] }

    before do
      Post.stub(:fetch_from_url => [[], 'title', 'lede', []])
    end

    it 'should return a Post object' do
      Post.new_from_url('url').should be_a(Post)
    end

    context 'given a post with keywords' do
      before do
        Post.stub(:fetch_from_url => [[], 'title', 'lede', keywords])
      end

      it 'returns a Post object with those keywords mapped to Backend Tokens' do
        Post.new_from_url('url').keywords.map(&:t).should == keywords.map { |p| p[0] }
      end
    end

    context 'given a post with images' do
      before do
        Post.stub(:fetch_from_url => [["file://#{Rails.root}spec/support/images/logo1.png"], 'title', 'lede', keywords])
      end

      it 'sets the image' do
        Post.new_from_url('url').image should be_present
      end
    end
  end

  describe '.fetch_from_url' do
    before do
      @blog_post = stub(
        :images => ["file://#{Rails.root}spec/support/images/logo1.png", "file://#{Rails.root}spec/support/images/logo2.png"],
        :lede => 'this is the leader of the post',
        :title => 'this is the title of the post',
        :keywords => [['keyword1', 3], ['keyword2', 2], ['keyword3', 1]],
      )
      Pismo::Document.stub(:new => @blog_post)
    end

    it 'should return a list of images from the article' do
      Post.fetch_from_url('http://example.com')[0].should == @blog_post.images
    end

    it 'should return a the title from the article' do
      Post.fetch_from_url('http://example.com')[1].should == @blog_post.title
    end

    it 'should return the lede from the article' do
      Post.fetch_from_url('http://example.com')[2].should == @blog_post.lede
    end

    it 'should return a list of keywords from the article' do
      Post.fetch_from_url('http://example.com')[3].should == @blog_post.keywords
    end
  end

  describe '#set_image_if_necessary' do
    it 'does nothing if the post already has an image'
    context 'when the post has no image' do
      it 'assigns the post the first image in the images array'
      it 'skips images that are smaller than 200px wide'
      it 'skips images that are smaller than 50px wide'
    end
  end
end
