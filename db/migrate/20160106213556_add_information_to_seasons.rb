class AddInformationToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :information, :text
  end
end
