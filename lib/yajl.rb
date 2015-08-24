require 'json'
require 'logger'
require "securerandom"

require "yajl/version"

module Yajl

  def create_logger(log_directory=nil)

    log_directory ||= "~/logs"

    user = `whoami`.chomp
    host = `hostname`.chomp

    project = `git rev-parse --show-toplevel`.chomp
    message = "logger only works within a git project"
    raise message if project == ""

    `mkdir -p #{log_directory}`

    project = project.split("/")[-1]

    logger = Logger.new("~/logs/#{user}@#{hostname}.#{project}.log")
    logger.level = Logger::INFO
    Logger.formatter = proc do |severity, datetime, progname, message|
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
