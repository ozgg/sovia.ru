module AboutHelper
  def link_to_ticket(ticket_number)
    link_to "##{ticket_number}", "https://github.com/ozgg/Sovia/issues/#{ticket_number}", rel: 'external'
  end
end