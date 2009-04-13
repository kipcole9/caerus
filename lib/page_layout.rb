# Template handler to make it easy to define page layouts using the 
# 960 Grid System ~ Core CSS. Learn more ~ http://960.gs/
# The basic idea is that your CSS defines and supports a grid based layout.
module PageLayout
  
  DOCTYPE = {
      :xhtml_strict => '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
      :xhtml_trans  => '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
  }

  TAGS      = [:div, :a, :img, :script, :meta]
  INDENT    = 2
  
  # So that capture does the right thing for us
  #def __in_erb_template
  #  true
  #end

  def doctype(type = DOCTYPE[:xhtml_strict])
    @doctype = store(type)
  end
  
  def javascripts(*args)
    store javascript_include_tag(*args)
  end
  
  def stylesheets(*args)
    store stylesheet_link_tag(*args)
  end
  
  def html(language = "en", &block)
    doctype unless @doctype
    with_tag(:html, :xmlns => "http://www.w3.org/1999/xhtml", :"xml:lang" => language, :lang => language) do
      store yield
    end
  end

  def head(options = {}, &block)
    @head = with_tag(:head) do
      if block_given?
        yield
      else
        stylesheets('application.css')
        javascripts(:defaults)
      end
    end
  end  
  
  # Options
  # :columns => n  (width of columns)
  # :prefix => 'container'; name of CSS class prefix
  def body(args = {}, &block)
    head unless @head
    default_options = {:columns => 12, :prefix => "container" }
    options = default_options.merge(args)
    with_tag(:body) do
      container do
        yield
      end
    end
  end
  
  def container(args = {}, &block)
    default_options = {:columns => 12, :prefix => "container" }
    options = default_options.merge(args)
    with_tag(:div, :class => "#{options[:prefix]}_#{options[:columns]}") do
      yield
    end
    with_tag(:div, :class => "clear")
  end
  
  def column(args)
    default_options = {:width => 3}
    options = default_options.merge(args)
    options[:class] = class_from_options(options)
    with_tag(:div, options) do
      yield
    end
  end
  
  def clear(options = {})
    default_options = {:class => "clear"}
    yield if block_given?
    with_tag(:div, default_options.merge(options))
  end
 
  def text(t)
    t
  end

  def panel(title, args = {})
    default_options = {:class => "box"}
    options = default_options.merge(args)
    include_flash_block = options.delete(:flash)
    errors_on = options.delete(:display_errors)
    with_tag(:div, options) do
      with_tag(:h2) do
        with_tag(:a) { store tt(title) }
      end
      display_flash if include_flash_block
      display_errors(errors_on) if errors_on      
      yield
    end
  end
  
  def block(args = {})
    default_options = {:class => "block"}
    options = default_options.merge(args)
    with_tag(:div, options) do
      yield
    end
  end
  
  def title(t)
    with_tag(:title) { store t }
  end

  def store(content)
    return unless content
    @level ||= 0
    spacing = " " * (@level * INDENT)
    @template.concat(spacing + content + "\n")
    content
  end
  
  def include(*args)
    store render(*args)
  end
  
  def keep(name, text = '')
    ivar = "@content_for_#{name}"
    temp_output_buffer = @output_buffer
    @output_buffer = ""
    block_given? ? yield : @output_buffer = text
    instance_variable_set(ivar, "#{instance_variable_get(ivar)}#{@output_buffer}")
    @output_buffer = temp_output_buffer
    nil
  end
  
  def p(text, options = {})
    with_tag(:p, options) do
      store text
    end
  end
  
  def img(*args)
    store image_tag(*args)
  end
  
  def fieldset(legend)
    with_tag(:fieldset) do
      with_tag(:legend) do
        store legend
      end
      yield
    end
  end
  
  def search(title = "Enter your search", options = {})
    default_options = {:class => :search}
    options = default_options.merge(options)
    with_tag(:form, :class => options[:class], :method => :put) do
      fieldset title do
        store "<input class='search text' name='search' type='text'/>"
      end
    end
  end
  
  def method_missing(method, *args, &block)
    if [:h4, :h3, :h2, :h1].include?(method)
      return nil if args.last.blank?
      with_tag(method) do
        store args.pop
      end
    else
      super
    end
  end
  
private
  def with_tag(tag, options = {}, &block)
    tag_start = []
    tag_start << "<#{tag.to_s}"
    options.each{|k, v| tag_start << "#{k.to_s}=#{quote(v.to_s)}"}
    store tag_start.join(' ') + '>'
    increment_level
    yield if block_given?
    decrement_level
    store("</#{tag.to_s}>")
    ''
  end

  def class_from_options(options)
    klass = []
    klass << "grid_" + options.delete(:width).to_s if options[:width]
    klass << ("prefix_" + options.delete(:before).to_s) if options[:before]
    klass << ("suffix_" + options.delete(:after).to_s) if options[:after]
    klass.join(' ')
  end
  
  def increment_level
    @level += 1
  end
  
  def decrement_level
    @level -= 1
    @level = 0 if @level < 0
  end
  
  def quote(s)
    '"' + s + '"'
  end

end  
  
  
  
#<title>No Expectations - Articles</title>	
#<meta http-equiv="content-type" content="text/html; charset=utf-8" />
#<link rel="icon" type="image/png" href="/hermes.png" />
#<link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.noexpectations.com.au/assets/apis.xml" />
#<link rel="pingback" href="http://www.noexpectations.com.au/xmlrpc/api" />
#<link href="http://www.noexpectations.com.au/stylesheets/hermes_1237099236.css" media="screen" rel="Stylesheet" type="text/css" />

#<meta name="description" content="People and places in images from around the world" />
#<meta name="author" content="Kip Cole" />
#<meta name="copyright" content="All content Copyright &amp;copy; Kip Cole 2004-2008. No content may be copied, stored or used without written permission." />
#<meta name="keywords" content="Bar Point, New South Wales, Australia" />
#<meta name="date" content="2009-03-11T13:30:05Z" />
#<link href="http://www.noexpectations.com.au/articles.rss" rel="alternate" title="RSS" type="application/rss+xml" />
#<link href="http://www.noexpectations.com.au/articles.atom" rel="alternate" title="ATOM" type="application/atom+xml" />