module PostsHelper
  # @param [Post] post
  # @param [User] user
  # @param [String] text
  # @param [Hash] options
  def post_link(post, user, text = post.title, options = {})
    if post.visible_to? user
      link_to (text || t(:untitled)), post_path({ id: post.id }.merge(options))
    else
      raw "<span class=\"not-found\">[post #{post.id}]</span>"
    end
  end
end
