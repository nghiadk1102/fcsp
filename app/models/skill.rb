class Skill < ApplicationRecord
  has_many :job_skills, dependent: :destroy
  has_many :jobs, through: :job_skills
  has_many :skill_users, dependent: :destroy
  has_many :users, through: :skill_users

  belongs_to :group_skill

  validates :name, presence: true, uniqueness: true,
    length: {maximum: Settings.max_length_title}
  validates :description, length: {maximum: Settings.max_length_description}

  accepts_nested_attributes_for :skill_users
end
