module Commands
  class Gzip
    def initialize(source:, destination:, logger:)
      @source = source
      @destination = destination
      @logger = logger
    end

    def call
      logger.info 'Gzipping the output'
      tty_command.run(gzip_command)
    end

    private

    def gzip_command
      "gzip < #{source} > #{destination}"
    end

    attr_reader :source, :destination, :logger

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end
