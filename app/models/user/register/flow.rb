class User
  module Register
    class Flow < Micro::Case
      flow Step::NormalizeParams,
           Step::ValidatePassword,
           Step::CreateRecord,
           Step::SerializeAsJson
    end
  end
end
