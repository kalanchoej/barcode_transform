#!/usr/bin/ruby

def rebarcode_file(file, prefix)
  find = /(datafield tag="852".*code="p">)(\d*)/
  f = File.new(file, "r+")
  newfile = Array.new
  f.readlines.each_with_index do |line, index|
    if line.match(find)
        # if $2.to_s.length < 10
        #   newfile << line.gsub(find, $1+prefix+$2.rjust(9,"0"))
        # else
        #   puts "Barcode longer than 10 digits: " + $2
        # end
        newfile << line.gsub(find) { |s|
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
  f.rewind
  f.puts newfile
  f.close
end

rebarcode_file("gc-xml-forbarcodeconversion.xml", "33577")