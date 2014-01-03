module CollectionHelper
  def collection_item_prop_include?(class_collection, :property, value)
    ret = false
    class_collection.each do |c|
      ret = true if c.send(:property) == value
    end
    return ret
  end
end
