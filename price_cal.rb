require 'active_support'
require 'active_support/core_ext'

class Item
  @@items = {}

  #constructor  to initialize varibles
  def initialize(name, price)
    @@items[name] = price
  end
  
  def self.all
    return @@items
  end
end


class SaleItem
  @@sale_items = {}

  #constructor to initialize varibles
  def initialize(name, units, price)

    @@sale_items[name] = { 
      'units' => units, 
      'price' => price 
    }
  end

  def self.all
    return @@sale_items
  end
end
class PriceCalculator

  def generate_bill
    # user input of customer items
    puts "Please enter all the items purchased separated by a comma:"
    @customer_items = gets.chomp.split(/,/).map(&:to_s)

    items_quantity  = Hash.new(0)
    @customer_items.each { |item| items_quantity[item] += 1 }
    bill_summary    = calculate_total_bill(items_quantity)
    bill_display(items_quantity, bill_summary)
  end



  private

  def calculate_total_bill(items_quantity)
    summary = Hash.new()
    items_quantity.each do |product, value|

      selling_price = Item.all[product]
      sale_details  = SaleItem.all[product]

      #  calculate the normal price if no sales items
      if !sale_details.present?
        cost_price  = items_quantity[product] * selling_price

      else # Calculate the sale price and any extra products than the sale units
        discount_price  = (items_quantity[product] / sale_details['units']) * sale_details['price']
        cost_price      =  discount_price +  ((items_quantity[product] % sale_details['units']) * selling_price)
      end

      summary[product]  = cost_price
    end
    return summary
  end

def bill_display(items_quantity, bill_summary)
    purchased_products  = {}
    total_bill_price    = 0.0
    actual_total_price  = 0.0

    items_quantity.each do |product, no_of_items|
      purchased_products[product] ||= {
        units: no_of_items, 
        price: bill_summary[product]
      }
      total_bill_price    += bill_summary[product]
      actual_total_price  += (no_of_items * Item.all[product])
    end

    money_saved = (actual_total_price - total_bill_price).round(3)

    puts "Item      Quantity       Price"
    puts "--------------------------------------"
    purchased_products.each do | item, detail|
      puts "#{item}            #{detail[:units]}            #{detail[:price]}" 
    end
    puts "Total price : $#{total_bill_price}"
    puts "You saved $#{money_saved} today."
  end

end



begin
  Item.new('banana', 0.99)
  Item.new('apple', 0.89)
  Item.new('milk', 3.97)
  Item.new('bread', 2.17)
  SaleItem.new('milk', 2, 5.00)
  SaleItem.new('bread', 3, 6.00)
  
  
  
  price_calculator = PriceCalculator.new
  price_calculator.generate_bill
end
