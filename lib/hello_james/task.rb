require "forwardable"
require "fileutils"

module HelloJames
  class Task
    extend Forwardable

    attr_reader :task_group
    attr_reader :path

    def_delegators :task_group, :now, :logger, :context

    def initialize(task_group:, path:)
      @task_group = task_group
      @path = path
    end

    def run
      instance_eval(File.read(path), path)
    rescue => e
      logger.error(e)
    end
  end
end
