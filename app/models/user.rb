class User < ActiveRecord::Base
  validates :name, :length => {:minimum => 3,
    :maximum => 25,
    :too_short => "Usernames must have at least %{count} characters",
    :too_long => "Usernames cannot have less than %{count} characters"}
  validates :name, :uniqueness => {:message => "This username already exists"}
  validate :name_cannot_have_whitespace

  def name_cannot_have_whitespace
    if name.match /\s/
      errors[:name] << "Usernames cannot have spaces in them"
    end
  end

  attr_accessible :name
end

class NameValidator < ActiveModel::Validator
end
