class CreateVotes < ActiveRecord::Migration[6.1]
  def up
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :job_id
      t.boolean :status

      t.timestamps
    end
  end

  def down
    drop_table :votes
  end
end
