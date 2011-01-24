require 'find'
require 'fileutils'
require 'rubygems'

module ChangeNames
  VERSION = '0.5.2'


  class Changer
    include FileUtils::Verbose
    def initialize(path= "~/downloads/books")
      @path = File.expand_path(path)
    end

    def self.from_path(dir = "~/downloads/books")
      changer = Changer.new(dir)
      changer.change
    end

    PUBLISHERS = ['apress','oreilly','manning']
 

    def change_oreilly(file)
  #    newfile = file.gsub('Oreilly','OReilly')
      newfile = file.gsub(/o['.]?reilly/i, 'OReilly')
      newfile
    end
  
    def change(dir=@path)
      dirname = File.expand_path(dir)
      notchanged = []
      
      Find.find(dirname) do |path|
 
        next unless File.file?(path)
        dir,filename = File.split(path)  
        filename = filename.gsub(/[\s\-_]/, '.').squeeze('.')
        filename = change_oreilly(filename) if filename =~ /reilly/i
        #   #debugger
        #   filename = filename.sub(\1, 'OReilly')
        # end
        base,ext = [File.basename(filename,'.*'), File.extname(filename)]
        md = (/^(.+)(apress$|oreilly$|packt$|addison\.wesley$|wrox$|manning$|mcgraw\.hill|new\.riders|syngress|sitepoint$)/i).match base
        if md
          base = "#{md[2]}.#{md[1]}"
          filename = "#{base}#{ext}"
        end
        newpath = File.join(dir,filename).squeeze('.')
        
        if File.exist? newpath
          notchanged << newpath
          next
        end
        
        
        mv path, newpath
      end

      if !notchanged.empty?
        puts "*****************\n\nNot Changed\n***************"
        #notchanged.each{|path| puts path}
      end
    end
  end

  
  
end


if $0 == __FILE__

  changer = ChangeNames::Changer.from_path("~/downloads/books")
end

