# frozen_string_literal: true
# This migration comes from biovision_base_engine (originally 20190429111111)

# Add parsed body column to editable pages
class AddParsedBodyToEditablePages < ActiveRecord::Migration[5.2]
  def up
    return if column_exists?(:editable_pages, :parsed_body)

    add_column :editable_pages, :parsed_body, :text

    EditablePage.pluck(:id).each do |id|
      EditablePageBodyParserJob.perform_now(id)
    end
  end

  def down
    # No rollback needed
  end
end
