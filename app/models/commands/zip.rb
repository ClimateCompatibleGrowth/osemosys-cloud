module Commands
  class Zip
    def initialize(source:, destination:)
      @source = source
      @destination = destination
    end

    def call
      Osemosys::Config.logger.info 'Zipping the output'
      tty_command.run(zip_command)
    end

    private

    def zip_command
      "zip -j #{destination} #{source}"
    end

    attr_reader :source, :destination

    def tty_command
      @tty_command ||= TTY::Command.new(output: Osemosys::Config.logger, color: false)
    end
  end
end
