module AppUp
  class ConfigLoader < Struct.new(:filename)

    def run
      home = File.expand_path("~")
      config_file = File.join(home, filename)
      if File.exists?(config_file)
        load config_file
      end
    end
  end
end
