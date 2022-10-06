class User < ApplicationRecord
  self.table_name = "users"
  has_one_attached :avatar
  devise :database_authenticatable, :validatable,
  :jwt_authenticatable, jwt_revocation_strategy: self, authentication_keys: [:login]

  # attr_accessor :password
end
