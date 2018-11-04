module SyncFromYaml
  extend ActiveSupport::Concern

  class_methods do
    def define_active_record_to_yaml_attributes_map(active_record_attribute_name, yaml_attribute_name)
      (@active_record_to_yaml_attributes_map ||= Hash.new)[active_record_attribute_name.to_sym] = yaml_attribute_name.to_s
    end
    def active_record_to_yaml_attributes_map
      @active_record_to_yaml_attributes_map || Hash.new
    end

    def active_record_attributes_from_yaml(yaml)
      Hash[self.active_record_to_yaml_attributes_map.map {|active_record_attribute, yaml_attribute|
        [active_record_attribute, yaml[yaml_attribute]]
      }]
    end

    def create_from_yaml(attributes={}, yaml={})
      new_object = self.create(attributes.merge(self.active_record_attributes_from_yaml(yaml)))
      Rails.logger.info "\033[0;32mcreating\033[0;0m #{new_object.to_s}"
      new_object
    end

    def yaml_manifest
      @@yaml_manifest ||= (
        pathname = Rails.root.join('config', 'msu1tracks', 'videogame_manifest.yml')
        YAML.load(IO.read(pathname))
      )
    end

    def indexed_objects_for_yaml_sync=(_proc)
      @indexed_objects_for_yaml_sync_proc = _proc
    end
    def indexed_objects_for_yaml_sync(options={})
      if options[:reload]
        @indexed_objects_for_yaml_sync = @indexed_objects_for_yaml_sync_proc.call 
      else
        @indexed_objects_for_yaml_sync ||= @indexed_objects_for_yaml_sync_proc.call 
      end
    end
    def _indexed_objects_for_yaml_sync
      raise 'Implement in Class!'
    end

    def self.sync_manifest_with_database
      raise 'Implement in Class!'
    end
  end

  # instance methods
  def update_attributes_from_yaml(yaml)
    active_record_attributes_to_update = Hash[self.class.active_record_to_yaml_attributes_map.select {|active_record_attribute, yaml_attribute|
      self.send(active_record_attribute) != yaml[yaml_attribute]
    }.map {|active_record_attribute, yaml_attribute|
      [active_record_attribute, yaml[yaml_attribute]]
    }]

    unless active_record_attributes_to_update.empty?
      Rails.logger.info "\033[0;32mupdating\033[0;0m #{self.to_s} -> #{active_record_attributes_to_update.to_s}"
      self.update_attributes(active_record_attributes_to_update) 
    end
  end
end
