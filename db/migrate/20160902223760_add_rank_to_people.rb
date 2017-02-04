class AddRankToPeople < ActiveRecord::Migration
  def change
    add_column :people, :rank, :integer
  end
end
