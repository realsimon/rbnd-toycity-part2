require 'json'
require 'artii' # Artii gem: https://github.com/miketierney/artii.git

# replaced with "setup_files" method:
# path = File.join(File.dirname(__FILE__), '../data/products.json')
# file = File.read(path)
# products_hash = JSON.parse(file)

# Set up input/output files:
def setup_files
  report_file = $stderr
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  products_hash = JSON.parse(file)
  # Comment out next line for screen output:
  report_file = File.new('report.txt', 'w+')
  [products_hash, report_file]
end

# Use "artii" gem to print ascii art banner:
def print_banner(banner_text, output)
  banner = Artii::Base.new
  output.puts
  output.puts banner.asciify("   #{banner_text}")
  output.puts
end

def print_time(output)
  # Print today's date
  output.puts "   #{Time.new}"
end

# Calculate total:
def do_total(hash, field)
  total = hash.reduce(0.0) { |total, element| total + element[field].to_f }
  total.round(2)
end

# Print "products" part of sales report:
def products_report(files)
  input_hash = files[0]
  output = files[1]

  # For each product in the data set:
  input_hash['items'].each do |toy|
    # Print the name of the toy
    output.puts " #{toy['title']}"

    # Print the retail price of the toy
    output.puts " Retail price: #{toy['full-price']}"

    # Calculate and print the total number of purchases
    sales_num = toy['purchases'].count
    output.puts " Number sold: #{sales_num}"

    # Calculate and print the total amount of sales
    sales_sum = do_total(toy['purchases'], 'price')
    output.puts " Total amount of sales: #{sales_sum}"

    # Calculate and print the average price the toy sold for
    average_sale = sales_sum / sales_num
    output.puts " Average sale price: #{average_sale}"

    # Calculate and print the average discount (% or $) based off the average sales price
    output.puts " Average discount: #{((1 - (average_sale / toy['full-price'].to_f)) * 100).round(2)} %"

    output.puts
  end
end

def brands_report (files)
  input_hash = files[0]
  output = files[1]

  # Get all brands:
  brands = (input_hash['items'].map { |toy| toy['brand'] }).uniq

  # For each brand in the data set:
  brands.each do |brand|
    # Print the name of the brand
    output.puts " Brand: \"#{brand}\""

    # Select items for each brand
    brand_toys = input_hash['items'].select { |toy| toy['brand'] == brand }

    # Count and print the number of the brand's toys we stock
    output.puts " #{brand} inventory: #{do_total(brand_toys, 'stock').to_i}"

    # Calculate and print the average price of the brand's toys
    output.puts " Average price for #{brand}: #{do_total(brand_toys, 'full-price') / brand_toys.count}"

    # Calculate and print the total sales volume of all the brand's toys combined
    sales_vol = 0.0

    brand_toys.each do |toy|
      sales_vol += do_total(toy['purchases'], 'price')
    end

    output.puts " #{brand} sales volume: #{sales_vol.round(2)}"

    output.puts
  end
end

#
# *** Start report execution here: ***
#

files = setup_files

# Print "Sales Report" in ascii art
print_banner('Sales Report', files[1])

print_time(files[1])

# Print "Products" in ascii art
print_banner('Products', files[1])

products_report(files)

# Print "Brands" in ascii art
print_banner('Brands', files[1])

brands_report(files)
