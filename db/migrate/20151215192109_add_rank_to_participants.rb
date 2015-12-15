class AddRankToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :rank, :integer
  end
end
