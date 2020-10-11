module Commands
  class Zip
    def initialize(source:, destination:, logger:)
      @source = source
      @destination = destination
      @logger = logger
    end

    def call
      logger.info 'Zipping the output'
      tty_command.run(zip_command)
    end

    private

    def zip_command
      "zip -j #{destination} #{source}"
    end

    attr_reader :source, :destination, :logger

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end
