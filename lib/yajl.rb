require 'json'
require 'logger'
require "securerandom"

require "yajl/version"

def project
  result = `git rev-parse --show-toplevel`.chomp
  message = "logger only works within a git project"
  raise message if result == ""

  result
end

class YajlLogger < Logger

  %w{ warn info debug fatal error unknown }
    .each do |method_name|
    define_method(method_name) do |message, &block|

      return super(message, &block) if block

      sender = caller[0].split(":")[0]
      path = sender.split("/")
      project_depth = project.split("/").size

      if path[0..project_depth-1].join("/") == project
        path = path[project_depth..-1]
      end

      progname = path.join("/")
      super(progname) { message }
    end
  end

  # I don't want header lines
  def add_log_header(file)
  end

end

module Yajl

  def self.create_logger(log_directory=nil)

    unless log_directory == STDOUT || log_directory == false
      filename = Yajl.create_log_directory log_directory
      logger = YajlLogger.new(filename)
    else
      logger = YajlLogger.new(STDOUT)
    end

    logger.level = Logger::INFO
    logger.formatter = proc do |severity, datetime, progname, message|
      id = SecureRandom.hex(16)
      message = {text: message} if message.is_a? String
      line = { id: id,
               severity: severity,
               datetime: datetime.utc,
               progname: progname,
               message: message }
      JSON.generate(line) + "\n"
    end

    return logger

  end

  def self.create_log_directory(log_directory)

    log_directory ||= "~/logs"

    user = `whoami`.chomp
    hostname = `hostname`.chomp

    `mkdir -p #{log_directory}`
    project_name = project.split("/")[-1]

    File.expand_path("#{log_directory}/#{user}@#{hostname}.#{project_name}.log")

  end

end
