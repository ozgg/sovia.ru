json.data do
  json.patterns @collection do |pattern|
    json.partial! pattern
  end
end
