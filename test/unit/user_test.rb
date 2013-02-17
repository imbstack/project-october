require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "names are unique" do
    User.create(:name => "duplicate")
    assert_raise ActiveRecord::RecordNotUnique do
      User.create(:name => "duplicate")
    end
  end

  test "names contain no spaces" do
    assert false
  end
end
