module AppUp
  class Config

    @ignore = []

    class << self
      attr_accessor :ignore
    end

  end
end
