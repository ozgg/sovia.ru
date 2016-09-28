module DreamsHelper
  # @param [Dream] dream
  # @param [User] user
  # @param [String] text
  # @param [Hash] options
  def dream_link(dream, user, text = dream.title, options = {})
    if dream.visible_to? user
      link_to (text || t(:untitled)), dream_path({ id: dream.id }.merge(options))
    else
      raw "<span class=\"not-found\">[dream #{dream.id}]</span>"
    end
  end

  # @param [Dream] dream
  def admin_dream_link(dream)
    link_to (dream.title || t(:untitled)), admin_dream_path(dream)
  end
end
