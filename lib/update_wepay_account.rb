# ====================
# = Update Wepay API =
# => Used to update the donate_rd for each environment
# ====================

wp = Wepay.new
x = wp.put("/group/modify/#{APP_CONFIG[:givey]['group_id']}",{:donate_rd => "http://#{APP_CONFIG[:domain]}/donations/callback"})

begin
  puts "Updated Wepay for Group ID: #{x.result.id}"   
rescue Exception => e
  puts "Error updating Wepay - #{x.result.inspect}"
end

