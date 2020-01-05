# frozen_string_literal: true

# Create component and tables for Services
class CreateServices < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_services unless Service.table_exists?
    create_user_services unless UserService.table_exists?
  end

  def down
    drop_table :user_services if UserService.table_exists?
    drop_table :services if UserService.table_exists?
  end

  private

  def create_component
    slug = Biovision::Components::ServicesComponent.slug

    BiovisionComponent.create(slug: slug)
  end

  def create_services
    create_table :services, comment: 'Paid services' do |t|
      t.integer :priority, limit: 2, default: 1, null: false
      t.timestamps
      t.boolean :active, default: true, null: false
      t.boolean :visible, default: true, null: false
      t.boolean :highlighted, default: false, null: false
      t.integer :price, null: false
      t.integer :old_price
      t.integer :users_count, default: 0, null: false
      t.integer :duration, default: 0, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :image
      t.string :lead
      t.text :description
      t.jsonb :data, default: {}, null: false
    end
  end

  def create_user_services
    create_table :user_services, comment: 'Purchased services' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :service, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.integer :quantity, default: 1, null: false
      t.date :end_date
      t.jsonb :data, default: {}, null: false
    end
  end
end
