require 'spec_helper'

describe Post do
  describe '#types' do
    context 'when the post has an image' do
      subject { FactoryGirl.create(:image_post).types }
      it { should == Set.new([:feature_article, :square_article, :square_article_with_picture]) }
    end

    context 'when the post does not have an image' do
      subject { FactoryGirl.create(:post).types }
      it { should == Set.new([:square_article]) }
    end
  end

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
        Post.stub(:fetch_from_url => [["#{Rails.root}spec/support/images/logo1.png"], 'title', 'lede', keywords])
      end

      it 'sets the image' do
        Post.new_from_url('url').image should be_present
      end
    end
  end

  describe '.fetch_from_url' do
    before do
      @blog_post = stub(
        :images => ["#{Rails.root}spec/support/images/logo1.png", "#{Rails.root}spec/support/images/logo2.png"],
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
