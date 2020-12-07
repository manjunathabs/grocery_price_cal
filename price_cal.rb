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






begin
  Item.new('banana', 0.99)
  Item.new('apple', 0.89)
  Item.new('milk', 3.97)
  Item.new('bread', 2.17)
  SaleItem.new('milk', 2, 5.00)
  SaleItem.new('bread', 3, 6.00)
end
