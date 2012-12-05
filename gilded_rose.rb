#def normal_item item
  #unless 
#end
class ItemNames

  def self.especial_items_name
    {
    aged: 'Aged Brie',
    backstage: 'Backstage passes to a TAFKAL80ETC concert',
    sulfuras: 'Sulfuras, Hand of Ragnaros'
    }
  end

end

class EvaluateRules
  def initialize
    @especial_items =  ItemNames.especial_items_name
  end

  #this method is used to evalute the all items and we return 
  #true in case that the item name passed is diferent to the espcial item names
  def especial_item? item_name
    !@especial_items.find {|key, value| value == item_name}
    #this is the same becasuse find and detect return the first value where is diferent to false
    #ItemNames.especial_items.detect {|key, value| value == item_name}
  end
  def is_product_backstage? item_name
    @especial_items[:backstage] == item_name
  end

  def is_product_sulfuras? item_name
    @especial_items[:sulfuras] == item_name
  end

end


def update_quality(items)
  max_quality = 50
  min_quality = 0
  rules = EvaluateRules.new

  items_name = ItemNames.especial_items_name

  items.each do |item|
    
    if rules.especial_item? item.name
      if item.quality > min_quality
        item.quality -= 1
      end
    else
      if item.quality < max_quality
        item.quality += 1
        if rules.is_product_backstage? item.name
          if item.sell_in < 11
            if item.quality < max_quality
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < max_quality
              item.quality += 1
            end
          end
        end
      end
    end

    unless rules.is_product_sulfuras? item.name
      item.sell_in -= 1
    end

    if item.sell_in < 0
      if item.name != items_name[:aged]
        unless rules.is_product_backstage? item.name
          if item.quality > min_quality
            unless rules.is_product_sulfuras? item.name
              item.quality -= 1
            end
          end
        else
          item.quality = 0
        end
      else
        if item.quality < max_quality
          item.quality += 1
        end
      end
    end
  end
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

