class CreateShareJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :share_jobs do |t|
      t.integer :shareable_type
      t.integer :shareable_id
      t.references :user, foreign_key: true
      t.references :job, foreign_key: true

      t.timestamps
    end

    add_index :share_jobs, [:user_id, :job_id], unique: true
    add_index :share_jobs, :shareable_id
  end
end
