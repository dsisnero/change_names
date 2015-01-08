require 'find'
require 'fileutils'
require 'methadone'
require 'methadone/cli_logger'
require 'methadone/cli_logging'
require 'pathname'

module ChangeNames
  VERSION = '0.5.3'

  class OReilly

    def can_change?(path)
      path =~ /oreilly/i
    end

    def change(path)
      #    newfile = file.gsub('Oreilly','OReilly')
      path.gsub(/o['.]?reilly/i, 'OReilly')
    end

  end

  class Changer
    include FileUtils::Verbose
    include Methadone::Main
    include Methadone::CLILogging

    def initialize(path= "~/downloads/books")
      @path = Pathname(path).expand_path
      help_now!("Dir #{@path} not found") unless @path.directory?
    end

    def self.change_path(dir = "~/downloads/books")
      changer = Changer.new(dir)
      changer.change
    end

    PUBLISHERS = ['apress','oreilly','manning']

    def change_oreilly(file)
      #    newfile = file.gsub('Oreilly','OReilly')
      newfile = file.gsub(/o['.]?reilly/i, 'OReilly')
      newfile
    end

    def pdf_file?(file_path)
      file_path.file? && file_path.extname == '.pdf'
    end

    def find_pdf_files(dir)
      dirpath = Pathname(dir).expand_path
      unless dirpath.directory?
        fatal "Dir: #{dirpath} doesn't exist"
        raise "Directory doesn't exist"
      end
      result = []
      dirpath.find do |pn|
        next unless pdf_file?(pn)
        yield pn if block_given?
        result << pn
      end
      return result unless block_given?
    end

    def squeeze_file(filename)
      filename.gsub(/[\s\-_]/, '.').squeeze('.')
    end


    def change_pdf_file(file)
      return file unless pdf_file?(file)
      dir,basename = file.split
      base = basename.basename('.pdf')
      file_string = base.to_s
      sfile = squeeze_file(file_string)
      editor_file = change_editor(sfile)
      dir + "#{editor_file}.pdf"
    end

    def editor_regex
      @editor_re ||= /^(.+)(apress$|oreilly$|packt$|addison\.wesley$|wrox$|manning$|mcgraw\.hill|new\.riders|syngress|sitepoint$)/i
    end

    def change_editor(file)
      md = editor_regex.match file
      if md
        "#{md[2]}.#{md[1]}"
      else
        file
      end
    end

    def split_files_to_change(dir=@path)
      pdf_files = find_pdf_files(dir)
      not_changed = []
      to_change = []
      pdf_files.each do |fn|
        new_name = change_pdf_file(fn)
        if new_name == fn
          not_changed << new_name
        else
          to_change << [fn,new_name]
        end

      end
      [not_changed,to_change]
    end

    def change(dir=@path)
      not_changed,to_change = split_files_to_change(dir)
      to_change.each do |old,new|
        mv old, new
      end

      display_not_changed(not_changed)
    end


    def display_not_changed(not_changed=[])
      if !not_changed.empty?
        info "*****************\n\nNot Changed\n***************"
        not_changed.each{|path| puts path}
      end
    end




  end
end

  if $0 == __FILE__

    changer = ChangeNames::Changer.from_path("~/downloads/books")
  end
