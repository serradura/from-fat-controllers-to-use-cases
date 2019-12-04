class User < ApplicationRecord
  has_many :todos

  with_options presence: true do
    validates :name
    validates :token, length: { is: 36 }, uniqueness: true
    validates :password_digest, length: { is: 64 }
  end
end
