require "work_queue"
require "app_up/shell/color"

module AppUp
  module Shell
    class Runner
      include Color

      MAX_PROCESS_COUNT = 8
      CommandFailureError = Class.new(StandardError)

      attr_accessor :working_directory, :log_path, :queue
      private :working_directory, :log_path, :queue

      def initialize(log_path:, working_directory:, verbose: false)
        @working_directory = working_directory
        @log_path = log_path
        @verbose = verbose

        @queue = WorkQueue.new(MAX_PROCESS_COUNT, nil)

        %x{echo "" > #{log_path}}
        Dir.chdir(%x[ git rev-parse --show-toplevel ].chomp)
      end

      # The block passed to run is a callback. It is used
      # to add a dependent command to the queue.
      def run(cmd, dir: working_directory, &block)
        command = "cd #{Utils::Path.relative_join(dir)} && #{cmd}"
        handle_output_for(command)

        shell_out(command).split("\n").tap do
          block.call if block_given?
        end
      end

      def warn(msg)
        log msg.to_s
        print "#{red(msg.to_s)}\n"
      end

      def notify(msg)
        log msg.to_s
        print "#{yellow(msg.to_s)}\n"
      end

      def enqueue(method, *args, &block)
        queue.enqueue_b do
          send(method, *args, &block)
        end
      end

      def flush
        queue.join
      end

      private

      def log(msg)
        %x{echo "#{msg.to_s}" >> #{log_path}}
      end

      def handle_output_for(cmd)
        puts cmd if @verbose
        log(cmd)
      end

      def shell_out(command)
        %x{ set -o pipefail && #{command} 2>> #{log_path} | tee -a #{log_path} }.chomp.tap do
          warn "The following command has failed: #{command}.  See #{log_path} for a full log." if ($?.exitstatus != 0)
        end
      end

    end
  end
end
