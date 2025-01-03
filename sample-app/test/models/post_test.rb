# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @post = @user.posts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'user id should be present' do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test 'content should be present' do
    @post.content = '   '
    assert_not @post.valid?
  end

  test 'content should be at most 140 characters' do
    @post.content = 'a' * 141
    assert_not @post.valid?
  end

  test 'order should be most recent first' do
    assert_equal posts(:most_recent), Post.first
  end
end
