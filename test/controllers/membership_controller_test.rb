require "test_helper"

class MembershipControllerTest < ActionDispatch::IntegrationTest
  test "should get team" do
    get membership_team_url
    assert_response :success
  end

  test "should get ambassador" do
    get membership_ambassador_url
    assert_response :success
  end

  test "should get teacher" do
    get membership_teacher_url
    assert_response :success
  end

  test "should get teamIn" do
    get membership_teamIn_url
    assert_response :success
  end
end
