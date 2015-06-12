require 'net/http'

array_nodes = Array.new
def main(num)
	server = URI('http://172.16.18.138:8080//')

	objects_input = ("http://172.16.18.138:8080/api/sector/" + "#{num}" + "/objects").to_s
	objects = URI(objects_input)
	roots_input = ("http://172.16.18.138:8080/api/sector/" + "#{num}" + "/roots").to_s
	roots = URI(roots_input)
	collect_input = ("http://172.16.18.138:8080/api/sector/" + "#{num}" + "/company/hopeless/trajectory").to_s
	collect = URI(collect_input)
	
	ob_array = Array.new
	r_array = Array.new
	all_nodes_hash = Hash.new
	
	request = Net::HTTP.get(objects)
	ob_array = request
	request2 = Net::HTTP.get(roots)
	r_array = request2.split("\n")
	for x in 0..ob_array.size
			array = ob_array.split("\n")
			if array[x] == nil
				array.delete_at(x)
				break
			end
			array_nodes = array[x].split(" ")
			all_nodes_hash[array_nodes[0]] ||= []
			all_nodes_hash[array_nodes[0]] << array_nodes[1]
	end
	
	values_array = Array.new 
	
	for y in 0..all_nodes_hash.size
		if all_nodes_hash.has_key?(r_array[y])
			values_array = all_nodes_hash.values_at(r_array[y])
			
			for q in 0..values_array[0].size
			
				r_array << values_array[0][q]
				
				all_nodes_hash.each do |k, v|
				
					if k == r_array[y]
						all_nodes_hash.delete(r_array[y])
					end
					
				end
			end
		
		end
	end
		
	trajectory_array = Array.new
	
	all_nodes_hash.each do |k, v|	
		for i in 0..v.size-1
			trajectory_array = k
			trajectory_array += " "
			trajectory_array += v[i]
		end
		request = Net::HTTP.post_form(collect, 'trajectory' => trajectory_array)
		puts request.body
		trajectory_array.clear
	end
end
threads = (1..10).map do |i|
	Thread.new(i) do |i|
		main(i)
	end
end
threads.each {|t| t.join}
