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

begin
  puts "Executing SQL"
  ActiveRecord::Base.connection.execute npos.join(';')
  puts "Imported #{counter} charities into NPOS"
rescue Exception => e
  puts "Error: #{e.message}"
end