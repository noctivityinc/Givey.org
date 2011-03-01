def main
  npos = []
  counter = 0
  File.open("files/eopub780111.txt", "r") do |infile|
    print "Reading File."
    while (line = infile.gets)
      parts = line.split('    ',2)
      npos.push "INSERT INTO npos (name, active) VALUES (E'#{parts[0].gsub("'","")}',true)"
      counter += 1
      print '.' if (counter % 10000 == 0)
    end
  end

  Npo.where('id > 3').delete_all

  puts "."
  puts "Executing SQL"
  npos.each do |n|
    ActiveRecord::Base.connection.execute n
  end
  puts "Imported #{counter} charities into NPOS"
end
