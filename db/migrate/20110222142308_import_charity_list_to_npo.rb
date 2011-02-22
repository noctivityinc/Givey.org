class ImportCharityListToNpo < ActiveRecord::Migration
  def self.up
    begin
      drop_table :charities
    rescue Exception => e
    end

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
      npos.each do |npo|
        ActiveRecord::Base.connection.execute npo
      end
      puts "Imported #{counter} charities into NPOS"
    rescue Exception => e
      puts "Error: #{e.message}"
    end

    add_index :npos, :name
    add_index :npos, [:id, :name], :name => "index_id_name"

  end

  def self.down
    remove_index :npos, :name => :index_id_name
    remove_index :npos, :name
  end
end