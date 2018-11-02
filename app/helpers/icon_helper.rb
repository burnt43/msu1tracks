module IconHelper
  def self.icon_data
    @icon_data ||= YAML.load(IO.read(Rails.root.join('config', 'msu1tracks', 'icons.yml')))
  end

  def self.font_awesome_name(icon_name)
    self.icon_data.dig('icons', icon_name.to_s)
  end

  def application_icon(icon_name, options={})
    classes = ['fa', IconHelper.font_awesome_name(icon_name)]
    classes.push("fa-#{options[:size]}") if options.has_key?(:size)
    classes.concat([*options[:class]]) if options.has_key?(:class)

    capture_haml do
      haml_tag :i, class: classes.join(' ') do
      end
    end
  end
end
