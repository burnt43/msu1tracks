class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true
  ICON_YAML = YAML.load(IO.read(Rails.root.join('config', 'msu1tracks', 'icons.yml')))

  def self.icon_class
    ICON_YAML.dig('icons', 'models', self.model_name.param_key)
  end

  def self.all_indexed_by(*args)
    hash       = Hash.new
    sub_hash   = hash
    last_index = args.length - 1

    self.all.each {|object|
      args.each_with_index {|arg, index|
        sub_hash = (if arg.is_a?(Hash)
          key = object.send(arg.keys.first).send(arg.values.first)
          if index == last_index
            sub_hash[key] ||= object
            hash
          else
            sub_hash[key] ||= Hash.new
          end
        else
          key = object.send(arg)
          if index == last_index
            sub_hash[key] ||= object
            hash
          else
            sub_hash[key] ||= Hash.new
          end
        end)
      }
    }

    hash
  end
end
