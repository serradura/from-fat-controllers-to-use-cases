class User::Params
  def self.to_register(params)
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
