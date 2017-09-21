class UserTask < ApplicationRecord
  belongs_to :task
  belongs_to :user

  enum status: %i(init in_progress finished closed)
end
