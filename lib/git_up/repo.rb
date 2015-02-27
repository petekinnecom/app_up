module GitUp
  class Repo < Struct.new(:shell, :options)

    def files
      if options[:diff]
        diff(*options[:diff])
      else
        all
      end
    end

    private

    def all
      shell.run "git ls-tree --full-tree -r HEAD --name-only"
    end

    def diff(start_sha, end_sha)
      shell.run "git diff --name-only #{start_sha} #{end_sha}"
    end
  end
end
