class CreateUserCourseSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :user_course_subjects do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :subject_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.timestamps
    end
  end
end
