require 'spec_helper'

describe Post do
  describe '#image' do
    let(:the_post) { FactoryGirl.build(:post_from_url) }

    it 'is set to the first image in the list when the post is saved' do
      the_post.save
      the_post.image_url.should == the_post.images.first
    end

    it 'is not set if the post already has an image_url' do
      the_post.image_url = 'http://example.com/any_url.png'
      expect { the_post.save }.to_not change { the_post.image_url }
    end
  end

  describe '#type' do
    subject { FactoryGirl.create(:post).type }
    it { should == :square_article }
  end

  describe '.new_from_url' do
    before do
      Post.stub(:fetch_from_url => [[], 'title', 'lede', []])
    end

    it 'should return a Post object' do
      Post.new_from_url('url').should be_a(Post)
    end

    context 'given a post with keywords' do
      let(:keywords) { [['keyword1', 3], ['keyword2', 2]] }

      before do
        Post.stub(:fetch_from_url => [[], 'title', 'lede', keywords])
      end

      it 'returns a Post object with those keywords mapped to Backend Tokens' do
        Post.new_from_url('url').keywords.map(&:t).should == keywords.map { |p| p[0] }
      end
    end

    context 'given a post with images' do
      let(:images) { ['http://example.com/image1.jpg', 'http://example.com/image2.jpg'] }

      before do
        Post.stub(:fetch_from_url => [images, 'title', 'lede', []])
      end

      it 'returns a Post object with those images' do
        Post.new_from_url('url').images.should == images
      end

      it 'returns a Post object with its image_url as the first image' do
        Post.new_from_url('url').image_url.should == images.first
      end
    end
  end

  describe '.fetch_from_url' do
    before do
      @blog_post = stub(
        :images => ['http://example.com/image1.jpg', 'http://example.com/image2.jpg'],
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
end
