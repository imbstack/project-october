require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "names contain no spaces" do
    u = User.new(:name => "in space no one", :email => "a@b.com")
    if u.save
      assert false, "Whitespace was allowed in username"
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have spaces in them"
    end
  end

  test "names contain no special chars" do
    u = User.new(:name => "there'sa,inhere", :email => "a@b.com")
    if u.save
      assert false, "Special characters allowed in username"
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have special characters in them"
    end
  end

  test "names contain no twitter chars" do
    u = User.new(:name => "#YOLO", :email => "a@b.com")
    if u.save
      assert false, "Twitter characters allowed in username"
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have @ or # characters in them"
    end
  end

end
