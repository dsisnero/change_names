require 'find'
require 'fileutils'
require 'rubygems'

require 'ruby-debug'
class ChangeNames
  VERSION = '1.0.0'

  extend FileUtils::Verbose
  def initialize(path= "~/downloads/books")
    @path = File.expand(path)
  end

  def self.change(dir = "~/downloads/books")
    dirname = File.expand_path(dir)
    notchanged = []
    
    Find.find(dirname) do |path|
      next unless File.file?(path)
      dir,file = File.split(path)
      newfile = file.gsub(/[\s|-]/, '.').squeeze('.')
      if (/o'reilly/i) =~ newfile
        debugger
        newfile = newfile.sub(/o'reilly/i, 'OReilly')
      end
      base,ext = [File.basename(file,'.*'), File.extname(file)]
      md = (/^(.+)(apress$|oreilly$)/i).match base
      base = "#{md[2]}.#{md[1]}" if md      
      newfile = "#{base}#{ext}"
      newpath = File.join(dir,newfile).squeeze('.')
      if File.exist? newpath
        notchanged << newpath
        next
      end
      
      #puts "#{path} => #{newpath}"
      mv path, newpath
    end

    if !notchanged.empty?
      puts "*****************\n\nNot Changed\n***************"
      notchanged.each{|path| puts path}
    end
  end

  def self.change_back(dir = "~/My Dropbox/books")

    notchanged = []
    dirname = File.expand_path(dir)
    Find.find(dirname) do |path|
      next unless File.file?(path)
      dir,file = File.split(path)
      newfile = file.sub(/^(o)(.+)(ub$)/i,'\2\1\3')
      newpath = File.join(dir,newfile)
      if File.exist? newpath
        notchanged << newpath
        next
      end
      mv path, newpath
    end

    puts "\n\n***NOTCHANGED**\n\n"
    puts notchanged.join("\n")
  end
  
end


if $0 == __FILE__

  changer = ChangeNames.change("~/books")
end
  
