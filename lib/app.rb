require 'json'
#replaced with "setup_files" method:
#path = File.join(File.dirname(__FILE__), '../data/products.json')
#file = File.read(path)
#products_hash = JSON.parse(file)


$indent = "   "
$report_file = $stderr

def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    #$report_file = File.new("report.txt", "w+")
end

#Use command line "figlet" to print ascii art banner to a file or stderr
def print_banner(banner_text)
  banner = `figlet "#{$indent}#{banner_text}"`
  $report_file.puts
  $report_file.puts banner
end




setup_files

# Print "Sales Report" in ascii art
print_banner "Sales Report"

# Print today's date
$report_file.puts "#{$indent}#{Time.new}"

# Print "Products" in ascii art
print_banner "Products"

# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

# Print "Brands" in ascii art
print_banner "Brands"

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
