class UpdateTableVotesSetJobIdAsString < ActiveRecord::Migration[6.1]
  def change
    change_column :votes, :job_id, :string
  end
end
