module AppUp
  module Configuration
    class Config

      @ignore = []

      class << self
        attr_accessor :ignore
      end

    end
  end
end
