class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.all_indexed_by(attribute_name, options={})
    if options.has_key?(:parent_index)
      association_name      = options[:parent_index].keys.first
      association_attribute = options[:parent_index].values.first

      self.all.joins(association_name).each_with_object(Hash.new) {|object, hash|
        (hash[object.send(association_name).send(association_attribute)] ||= Hash.new)[object.send(attribute_name)] = object
      }
    else
      self.all.each_with_object(Hash.new) {|object, hash|
        hash[object.send(attribute_name)] = object
      }
    end
  end
end
