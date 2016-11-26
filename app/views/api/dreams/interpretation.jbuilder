json.data do
  json.patterns @patterns do |pattern|
    json.type pattern.class.table_name
    json.id pattern.id
    json.attributes do
      json.name pattern.name
      json.essence pattern.essence
    end
    json.links do
      json.self dreambook_word_path(word: pattern.name)
    end
  end
end