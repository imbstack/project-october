require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "names are unique" do
    User.create(:name => "duplicate")
    u = User.new(:name => "duplicate")
    if u.save
      assert false, "User was saved with duplicate name"
    else
      assert_includes u.errors.messages[:name], "This username already exists"
    end
  end

  test "names contain no spaces" do
    u = User.new(:name => "in space, no one")
    if u.save
      assert false, "Whitespace was allowed in username"
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have spaces in them"
    end
  end

  test "name cannot be too short" do
    u = User.new(:name => "a")
    if u.save
      assert false
    else
      assert_includes u.errors.messages[:name], "Usernames must have at least 3 characters"
    end
  end

  test "name cannot be too long" do
    u = User.new(:name => "thisnamehastoomanycharacters!")
    if u.save
      assert false
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have less than 25 characters"
    end
  end
end
