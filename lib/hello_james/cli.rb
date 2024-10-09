require "logger"
require "optparse"
require_relative "errors"
require_relative "task_group"

module HelloJames
  class Cli
    attr_reader :now
    attr_reader :context

    class << self
      def run(argv:)
        new(argv:).run
      end
    end

    def initialize(argv:)
      @argv = argv.dup
      @now = Time.now
      @context = {}

      opts = OptionParser.new
      opts.on("--now TIME") { @now = Time.parse(_1) }
      opts.parse(@argv)
    end

    def run
      task_dirs = %w[
        .hello_james
        ~/.hello_james
      ].map { File.expand_path(_1) }
      task_dirs.each do |task_dir|
        Dir.children(task_dir).each do |time_path|
          task_group = TaskGroup.new(runner: self, directory: File.join(task_dir, time_path))
          task_group.run if task_group.past_time?(now:)
        end
      rescue Errno::ENOENT => e
        logger.debug(e)
      end
    end

    def logger
      @logger ||= Logger.new($stderr).tap { _1.level = Logger::INFO }
    end
  end
end
