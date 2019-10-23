#! /usr/bin/env ruby

require 'optparse'

options = {
    :parent_file => "index.md" ,
    :parts_folder => "parts" ,
    :suffix => "pandoc"
}
usage = "ruby include_markdown.rb [options]"

OptionParser.new do |opts|
    opts.banner = usage
    opts.separator ""
    opts.separator "Options:"
  
    opts.on("-p", "--parentfile STRING", String, "Path to the file in which snippets are to be included. Default is 'index.md'.") do |parentfile|
      options[:parent_file] = parentfile
    end

    opts.on("-f", "--folder STRING", String, "Path to the folder containing snippets to be included. Default is 'parts'.") do |parts_folder|
      options[:parts_folder] = parts_folder
    end
  
    opts.on("-s", "--suffix STRING", String, "Suffix of the markdown files to be included. Default is 'pandoc'.") do |suffix|
      options[:suffix] = suffix
    end
      
end.parse!

text = File.read(options[:parent_file])

text.gsub!(/\@include\(([^)]+?)\)/) do |include_statement|
    replacement_path = File.join(options[:parts_folder], "#{$1}.#{options[:suffix]}")
    File.read(replacement_path)
end

puts text