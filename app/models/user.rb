# encoding: UTF-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  validates :name, :length => {:minimum => 3,
    :maximum => 25,
    :too_short => "Usernames must have at least %{count} characters",
    :too_long => "Usernames cannot have less than %{count} characters"}
  validates :name, :uniqueness => {:message => "This username already exists"}
  validate :name_cannot_have_whitespace
  validate :name_cannot_have_special_chars
  validate :name_cannot_have_twitter_chars

  def name_cannot_have_whitespace
    if name.match /\s/
      errors[:name] << "Usernames cannot have spaces in them"
    end
  end

  def name_cannot_have_special_chars
    if name.match /[^\p{L}]/
      errors[:name] << "Usernames cannot have special characters in them"
    end
  end

  def name_cannot_have_twitter_chars
    if name.match /[@#]/
      errors[:name] << "Usernames cannot have @ or # characters in them"
    end
  end
end
