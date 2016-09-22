module PostsHelper
  # @param [Post] post
  # @param [User] user
  def post_link(post, user)
    if post.visible_to? user
      link_to post.title, post
    else
      raw "<span class=\"not-found\">[post #{post.id}]</span>"
    end
  end
end
