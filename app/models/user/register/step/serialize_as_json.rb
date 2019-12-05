class User::Register::Step::SerializeAsJson < Micro::Case
  attribute :user

  validates! :user, type: User

  def call!
    Success do
      { user: user.as_json(only: [:id, :name, :token]) }
    end
  end
end
