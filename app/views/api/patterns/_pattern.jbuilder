json.pattern do
  json.(pattern, :id, :name, :essence, :description, :deleted, :locked, :dreams_count)
  json.flags do
    json.described do
      json.name t('activerecord.attributes.pattern.described')
      json.value pattern.described
    end
  end
  json.word_ids pattern.word_ids
end
