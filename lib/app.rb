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
  $report_file.puts
end

def do_total(hash, field)
  total = 0.0
  total = hash.inject(total) {|total, element | total + element[field].to_f}
  return total.round(2)
end



def products_report

  # Print "Products" in ascii art
  print_banner "Products"


# For each product in the data set:
  $products_hash["items"].each do |toy|

	# Print the name of the toy
  $report_file.puts toy["title"]

  # Print the retail price of the toy
  $report_file.puts "Retail price: #{toy["full-price"]}"

	# Calculate and print the total number of purchases
  sales_num = toy["purchases"].count
  $report_file.puts "Number sold: #{sales_num}"

	# Calculate and print the total amount of sales
  sales_sum = do_total(toy["purchases"],"price")
  $report_file.puts "Total amount of sales: #{sales_sum}"

	# Calculate and print the average price the toy sold for
  average_sale = sales_sum / sales_num
  puts "Average sale price: #{average_sale}"

	# Calculate and print the average discount (% or $) based off the average sales price
  puts "Average discount: #{((1 - (average_sale / toy["full-price"].to_f)) * 100).round(2)} %"

  puts
  end
end

# Print "Brands" in ascii art
print_banner "Brands"

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined


setup_files

# Print "Sales Report" in ascii art
print_banner "Sales Report"

# Print today's date
$report_file.puts "#{$indent}#{Time.new}"

products_report
