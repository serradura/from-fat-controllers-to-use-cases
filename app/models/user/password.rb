class User::Password
  attr_reader :value

  delegate :present?, :blank?, to: :value

  def initialize(value)
    @value = value&.strip
  end

  def ==(password)
    self.value == password.value
  end

  def digest
    @digest ||= Digest::SHA256.hexdigest(value)
  end

  alias_method :to_str, :value
end
