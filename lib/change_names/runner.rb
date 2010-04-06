require 'change_names/changer'
require 'change_names/options'

module ChangeNames
  class Runner

    def initialize(argv)
      @options = Options.new(argv)
    end
    
    def run
      changer = Changer.from_path(@options.directory)
      
    end
  end
end
