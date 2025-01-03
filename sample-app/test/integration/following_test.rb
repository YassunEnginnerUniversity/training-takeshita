require 'test_helper'

class Following < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end
end

class FollowPagesTest < Following
  test 'followees page' do
    get followees_user_path(@user)
    assert_response :success
    assert_not @user.followees.empty?
    assert_match @user.followees.count.to_s, response.body
    @user.followees.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_response :success
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end

class FollowTest < Following
  test 'should follow a user the standard way' do
    assert_difference '@user.followees.count', 1 do
      post follow_users_path, params: { followee_id: @other.id }
    end
    assert_redirected_to @other
  end

  test 'should follow a user with Hotwire' do
    assert_difference '@user.followees.count', 1 do
      post follow_users_path(format: :turbo_stream),
           params: { followee_id: @other.id }
    end
  end
end

class Unfollow < Following
  def setup
    super
    @user.follow(@other)
    @follow_user = @user.active_relationships.find_by(followee_id: @other.id)
  end
end

class UnfollowTest < Unfollow
  test 'should unfollow a user the standard way' do
    assert_difference '@user.followees.count', -1 do
      delete follow_user_path(@follow_user)
    end
    assert_response :see_other
    assert_redirected_to @other
  end

  test 'should unfollow a user with Hotwire' do
    assert_difference '@user.followees.count', -1 do
      delete follow_user_path(@follow_user, format: :turbo_stream)
    end
  end
end
