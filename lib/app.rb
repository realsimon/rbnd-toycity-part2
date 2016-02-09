require 'json'
require 'artii'   #Artii gem: https://github.com/miketierney/artii.git

#replaced with "setup_files" method:
#path = File.join(File.dirname(__FILE__), '../data/products.json')
#file = File.read(path)
#products_hash = JSON.parse(file)


$indent = "   "
$report_file = $stderr

# Set up input/output files:
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    # Comment out next line for screen output:
    $report_file = File.new("report.txt", "w+")
end

# Use "artii" gem to print ascii art banner:
def print_banner(banner_text)
  banner = Artii::Base.new
  $report_file.puts
  $report_file.puts banner.asciify("#{$indent}#{banner_text}")
  $report_file.puts
end

# Calculate total:
def do_total(hash, field)
  total = hash.reduce(0.0) {|total, element | total + element[field].to_f}
  return total.round(2)
end


# Print "products" part of sales report:
def products_report

  # Print "Products" in ascii art
  print_banner "Products"


# For each product in the data set:
  $products_hash["items"].each do |toy|

	# Print the name of the toy
  $report_file.puts " #{toy["title"]}"

  # Print the retail price of the toy
  $report_file.puts " Retail price: #{toy["full-price"]}"

	# Calculate and print the total number of purchases
  sales_num = toy["purchases"].count
  $report_file.puts " Number sold: #{sales_num}"

	# Calculate and print the total amount of sales
  sales_sum = do_total(toy["purchases"],"price")
  $report_file.puts " Total amount of sales: #{sales_sum}"

	# Calculate and print the average price the toy sold for
  average_sale = sales_sum / sales_num
  $report_file.puts " Average sale price: #{average_sale}"

	# Calculate and print the average discount (% or $) based off the average sales price
  $report_file.puts " Average discount: #{((1 - (average_sale / toy["full-price"].to_f)) * 100).round(2)} %"

  $report_file.puts
  end
end

def brands_report

  # Print "Brands" in ascii art
  print_banner "Brands"

  # Get all brands:
  brands = ($products_hash["items"].map {|toy| toy["brand"]}).uniq

  # For each brand in the data set:
  brands.each do |brand|

    # Print the name of the brand
    $report_file.puts " Brand: \"#{brand}\""

    # Select items for each brand
    brand_toys = $products_hash["items"].select {|toy| toy["brand"] == brand}

    # Count and print the number of the brand's toys we stock
    $report_file.puts " #{brand} inventory: #{do_total(brand_toys, "stock").to_i}"

    # Calculate and print the average price of the brand's toys
    $report_file.puts " Average price for #{brand}: #{do_total(brand_toys, "full-price") / brand_toys.count }"

	  # Calculate and print the total sales volume of all the brand's toys combined
    sales_vol = 0.0

    brand_toys.each do |toy|
      sales_vol += do_total(toy["purchases"],"price")
    end

    $report_file.puts " #{brand} sales volume: #{sales_vol.round(2)}"

    $report_file.puts
  end
end


#
# *** Start report execution here: ***
#

setup_files

# Print "Sales Report" in ascii art
print_banner "Sales Report"

# Print today's date
$report_file.puts "#{$indent}#{Time.new}"

products_report

brands_report
