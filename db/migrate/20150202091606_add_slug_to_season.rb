class AddSlugToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :slug, :string
  end
end
