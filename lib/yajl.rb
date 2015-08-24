require 'json'
require 'logger'
require "securerandom"

require "yajl/version"

class Logger::LogDevice
  def add_log_header(file)
  end
end

module Yajl

  def self.create_logger(log_directory=nil)

    log_directory ||= "~/logs"

    user = `whoami`.chomp
    hostname = `hostname`.chomp

    project = `git rev-parse --show-toplevel`.chomp
    message = "logger only works within a git project"
    raise message if project == ""

    `mkdir -p #{log_directory}`

    project = project.split("/")[-1]

    filename = File.expand_path("~/logs/#{user}@#{hostname}.#{project}.log")
    logger = Logger.new(filename)

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
end
