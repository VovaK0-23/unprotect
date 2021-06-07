#!/usr/bin/ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rubyzip'
  gem 'rake'
end

require 'zip'
require 'rake'

puts 'Enter file name which needs to be unprotected'
old_file = gets.chomp
new_file = old_file.ext('zip')
File.rename(old_file, new_file)

Zip::File.open(new_file) do |zip_file|
  zip_file.each do |entry|
    next unless entry.name.include?('xl/worksheets/sheet')

    contents = zip_file.read(entry.name).split(/<sheetProtection[^>]*>/).join
    zip_file.get_output_stream(entry.name) { |f| f << contents }
    zip_file.close
  end
end

File.rename(new_file, old_file)
puts 'Done!'
