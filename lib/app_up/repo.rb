module AppUp
  class Repo < Struct.new(:shell, :options)

    private :shell, :options

    def files
      ignores = options.has_key?(:ingore) ? options[:ignore] : Configuration::Config.ignore
      default_files.reject {|f| ignores.any? {|i| f.match(i)} }
    end

    private

    def default_files
      if options[:diff]
        diff(*options[:diff])
      else
        all
      end
    end

    def all
      shell.run "git ls-tree --full-tree -r HEAD --name-only"
    end

    def diff(start_sha, end_sha)
      shell.run "git diff --name-only #{start_sha} #{end_sha}"
    end
  end
end
