class User
  module Register
    class Flow
      include Micro::Case::Flow

      flow Step::NormalizeParams,
           Step::ValidatePassword,
           Step::CreateRecord,
           Step::SerializeAsJson
    end
  end
end
