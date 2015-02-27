require 'work_queue'

module GitUp
  class ShellRunner
    MAX_PROCESS_COUNT = 8
    CommandFailureError = Class.new(StandardError)

    attr_accessor :working_directory, :log_path, :queue
    private :working_directory, :log_path, :queue

    def initialize(log_path:, working_directory:)
      @working_directory = working_directory
      @one_liner = ''
      @log_path = log_path
      @queue = WorkQueue.new(MAX_PROCESS_COUNT, nil)
      Dir.chdir(%x[ git rev-parse --show-toplevel ].chomp)

      reset_log
    end

    def run(cmd, dir: working_directory)
      command = "cd #{dir} && #{cmd}"
      handle_output_for(command)
      shell_out(command).split("\n")
    end

    def warn(msg)
      log msg.to_s
      puts msg.to_s.red
    end

    def notify(msg)
      log msg.to_s
      puts msg.to_s.yellow
    end

    def flush
      queue.join
      @queue = WorkQueue.new(MAX_PROCESS_COUNT, nil)
    end

    def enqueue(method, *args)
      queue.enqueue_b do
        send(method, *args)
      end
    end

    private

    def log(msg)
      %x{echo "#{msg.to_s}" >> #{log_path}}
    end

    def reset_log
      %x{echo "" > #{log_path}}
    end

    def handle_output_for(cmd)
      puts cmd
      log(cmd)
    end

    def shell_out(command)
      %x{ set -o pipefail && #{command} 2>> #{log_path} | tee -a #{log_path} }.chomp.tap do
        warn "The following command has failed: #{command}.  See #{log_path} for a full log." if ($?.exitstatus != 0)
      end
      return $?.exitstaus == 0
    end

  end
end

#PETE: hack

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end
