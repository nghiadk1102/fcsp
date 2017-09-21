class Subject < ApplicationRecord
  has_many :user_course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :tasks
end
