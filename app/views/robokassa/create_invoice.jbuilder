json.data do
  json.id @entity.id
  json.type @entity.class.table_name
  json.attributes do
    json.call(@entity, :price, :email)
  end
  json.meta do
    json.interpretation_count @entity.data.dig('sovia', Biovision::Components::DreamsComponent::REQUEST_COUNTER)
  end
end
json.meta do
  json.robokassa do
    json.is_test @handler.is_test
    json.login Biovision::Components::Invoices::RobokassaHandler::LOGIN
    json.out_sum @handler.invoice.price.to_f.to_s
    json.inv_id @entity.id
    json.signature @handler.signature
  end
end
