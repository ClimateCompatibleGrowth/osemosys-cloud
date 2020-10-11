module Commands
  class ZipFolder
    def initialize(folder:, destination:, logger:)
      @folder = folder
      @destination = destination
      @logger = logger
    end

    def call
      logger.info 'Zipping the folder'
      tty_command.run(zip_command)
    end

    private

    def zip_command
      "zip -r #{destination} #{folder}"
    end

    attr_reader :folder, :destination, :logger

    def tty_command
      @tty_command ||= TTY::Command.new(output: logger, color: false)
    end
  end
end
