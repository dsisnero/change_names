require 'optparse'
require 'methadone/cli_logging'
module ChangeNames

  class Options

    include Methadone::CLILogging

    DEFAULT_DIRECTORY = File.expand_path("~/downloads/books")
    attr_reader :directory

    def initialize(argv)
      @directory = DEFAULT_DIRECTORY
      parse(argv)
    end

  private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage:  change_names[ options ]"

        opts.on("-d", "--dir path", String, "Path to change") do |dir|
          @directory = dir
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          #argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
