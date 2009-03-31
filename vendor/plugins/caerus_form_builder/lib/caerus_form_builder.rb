class CaerusFormBuilder < ActionView::Helpers::FormBuilder
  DEFAULT_SUFFIX  = ":"
  
  # Default class definitions
  FORM_FIELD      = "formField"
  LABEL           = "formLabel"
  FORM_TEXT       = "formText"
 
  # Standard input fields; wrapped in a standard wrapper and with
  # my usual defaults
  def text_field(method, options = {})
    default_options = {:size => 30}
    field_options = {:before => options.delete(:before), :after => options.delete(:after)}
    after = options[:after] | ""
    with_field(method, field_options) do
      super(method, default_options.merge(options))
    end
  end
  
  def password_field(method, options = {})
    default_options = {:size => 30}
    with_field(method) do
      super(method, default_options.merge(options))
    end
  end
    
  def hidden_field(method, options = {})
    default_options = {}
    @template.concat super
  end
     
  def text_area(method, options = {})
    default_options = {:size => "50x5"}
    with_field(method) do
      super(method, default_options.merge(options))
    end 
  end

  def file_field(method, options = {})
    default_options = {:size => 50}
    with_field(method) do
      super(method, default_options.merge(options))
    end   
  end
   
  def select(method, choices, options = {}, html_options = {})
    default_html_options = {}
    with_field(method, options) do
      super(method, choices, options, default_html_options.merge(html_options))
    end
  end  
   
  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    default_options = {}
    with_field(method, :label_class => "checkbox") do
      super(method, default_options.merge(options), checked_value, unchecked_value)
    end
  end
    
  def country_select(method, priority_countries = nil, options = {}, html_options = {})
    default_html_options = {}
    with_field(method) do
      super(method, priority_countries, options, default_html_options.merge(options))
    end
  end
  
  def datetime_select(method, options = {}, html_options = {})
    default_html_options = {}
    with_field(method) do
      super(method, options, default_html_options.merge(options))
    end
  end
 
  def date_select(method, options = {}, html_options = {})   
    default_html_options = {}
    with_field(method) do
      super(method, options, default_html_options.merge(options))
    end
  end
  
  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    default_html_options = {}
    with_field(method) do
      super(method, priority_zones, options, default_html_options.merge(html_options))
    end
  end
  
  def buttons(*args)
    if args.include?(:delete)
      hidden_field('_delete')
    end
    @template.buttons(args)
  end
    
private  

  # Standard field definitions
  def with_field(method, options = {}, &block)
    field_definition = @template.capture(&block)
    field_id = field_definition.match(/id=\"(.+?)\"/)[1]
    before = options[:before] || ""
    after = options[:after] || ""
    label = ''
    prompt = get_prompt(object_name, method)
    unless options.delete(:no_label)
      label_class = []
      label_class << options.delete(:label_class) if options[:label_class]
      label = @template.content_tag(:label, format_label(method), :for => "#{field_id}", :class => label_class.join(' '))
    end
    content = @template.content_tag(:p, label + \
      @template.content_tag(:span, "", :id => "#{field_id}_message", :class => 'field_message') + \
      before + field_definition + after) 
    content += @template.content_tag(:p, prompt, :class => "prompt") unless prompt.blank?
    @template.concat(content + "\n") if File.extname(@template.template.filename) == ".rb" 
  end

  def spinner_images(object_name, method)
    "<img id='#{object_name}_#{method}_spinner' src='/images/spinners/arrows.gif' class='spinner' style='display:none' />" + \
    "<img id='#{object_name}_#{method}_cross' src='/images/icons/cross.png' class='spinner' style='display:none' />" + \
    "<img id='#{object_name}_#{method}_tick' src='/images/icons/tick.png' class='spinner' style='display:none' />"
  end
  
  def format_label(label, options = {})
    label = object.class.human_attribute_name(label.to_s) + (options[:suffix] || DEFAULT_SUFFIX)
  end
  
  def get_prompt(table, column)
    prompt = I18n.translate("column_descriptions.#{object_name}.#{column}", :default => "none")
    prompt = I18n.translate("column_descriptions.#{column}", :default => "") if prompt == "none"
    return prompt
  end
  
end


