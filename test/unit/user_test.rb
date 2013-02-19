require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "names contain no spaces" do
    u = User.new(:name => "in space, no one", :email => "a@b.com")
    if u.save
      assert false, "Whitespace was allowed in username"
    else
      assert_includes u.errors.messages[:name], "Usernames cannot have spaces in them"
    end
  end

end
