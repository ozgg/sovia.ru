module DreamsHelper
  # @param [Dream] dream
  # @param [User] user
  def dream_link(dream, user)
    if dream.visible_to? user
      link_to (dream.title || t(:untitled)), dream
    else
      raw "<span class=\"not-found\">[dream #{dream.id}]</span>"
    end
  end

  # @param [Dream] dream
  def admin_dream_link(dream)
    link_to (dream.title || t(:untitled)), admin_dream_path(dream)
  end
end
