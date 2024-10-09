require_relative "task"
require "time"
require "forwardable"

module HelloJames
  class TaskGroup
    extend Forwardable

    attr_reader :runner
    attr_reader :directory

    def_delegators :runner, :now, :logger, :context

    def initialize(runner:, directory:)
      @runner = runner
      @directory = directory
      @time_string = File.basename(@directory)
    end

    def past_time?(now:)
      @time_string <= now.strftime("%H:%M")
    end

    def run
      tasks.each(&:run)
    end

    def tasks
      @tasks ||= Dir.children(directory).map { |task_name|
        Task.new(task_group: self, path: File.join(directory, task_name))
      }.sort_by { _1.path }
    end
  end
end
