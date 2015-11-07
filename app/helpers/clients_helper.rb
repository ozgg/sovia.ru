module ClientsHelper
  def clients_for_select
    [[t(:not_selected), '']] + Client.by_name.map { |client| [client.name, client.id] }
  end
end
