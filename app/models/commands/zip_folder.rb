module Commands
  class ZipFolder
    def initialize(folder:, destination:)
      @folder = folder
      @destination = destination
    end

    def call
      Osemosys::Config.logger.info 'Zipping the folder'
      tty_command.run(zip_command)
    end

    private

    def zip_command
      "zip -r #{destination} #{folder}"
    end

    attr_reader :folder, :destination

    def tty_command
      @tty_command ||= TTY::Command.new(output: Osemosys::Config.logger, color: false)
    end
  end
end
