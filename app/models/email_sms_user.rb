class EmailSmsUser < User
  self.table_name = "users"
  has_many :otps, dependent: :destroy, foreign_key: :user_id
end