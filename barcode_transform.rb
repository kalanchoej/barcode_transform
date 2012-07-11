#!/usr/bin/ruby
# barcode_transform.rb 
# Justin Hopkins https://github.com/hopkinsju/barcode_transform

def rebarcode_file(file, field, subfield, prefix, verbose=false)
  find = /(datafield tag="#{field}".*code="#{subfield}">)(\d*)/
  f = File.new(file, "r")
  t = File.new(file+".transformed", "w+")
  newfile = Array.new
  # processed = 0
  # unprocessed = 0
  f.readlines.each_with_index do |line, index|
    if line.match(find)
        newfile << line.gsub(find) { |s|
          # TODO: add some logging/statistics in here. How many records were processed/unprocessed/
          # /appears to already be transformed (14 digits (maybe barcode total length could be set
          # in a variable...))
          if $2.to_s.length < 10
            $1+prefix+$2.rjust(9,"0")
          else
          	puts "Barcode too long to process. Has this barcode already been transformed? \n" + $2
          	$1+$2
          end	
        }
    else
      newfile << line
    end
  end
  t.puts newfile
  f.close
  t.close
end

def help()
  STDOUT.flush
  STDOUT.puts <<-EOF
  A utility to parse a MARC XML file and lengthen the item barcodes by adding a 5 digit prefix
  and a number of zero's to bring it up to 14 characters. This script was designed for a fairly
  specific purpose and may well not work for yours. Sorry. Patches welcome ;-)
    
  Usage:
  barcode_transform.rb file field subfield prefix [verbose]
  
  Required Parameters:
  
  file: The input file in MARCXML format
  
  field: the marc field that contains the barcode you're wanting to transform

  subfield: The subfield where the barcode lives

  prefix: A 5 digit prefix to go at the beginning of the barcode.
  
  EOF
end

# Read this: http://www.skorks.com/2009/08/how-a-ruby-case-statement-works-and-what-you-can-do-with-it/
# Use a case statement to walk the user through a series of questions to populate the variables we need
# if they aren't already as command line parameters. Also add a check for proper input types - 
# the field should be numeric and 3 digits long right?
if ARGV.length < 4 
  help
  abort("Missing parameters")
end

file = ARGV[0]
field = ARGV[1]
subfield = ARGV[2]
prefix = ARGV[3]

rebarcode_file(file, field, subfield, prefix)



