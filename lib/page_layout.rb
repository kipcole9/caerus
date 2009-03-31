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
    @body = with_tag(:body) do
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
  
  def clear
    yield if block_given?
    with_tag(:div, :class => "clear")
  end
 
  def text(t)
    t
  end

  def panel(title, args = {})
    default_options = {:class => "box"}
    options = default_options.merge(args)
    with_tag(:div, options) do
      with_tag(:h2) do
        with_tag(:a) { store tt(title) }
      end
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
    @level ||= 0
    spacing = " " * (@level * INDENT)
    @template.concat(spacing + content + "\n")
    content
  end
  
  def include(*args)
    store render(*args)
  end
  
private
  def with_tag(tag, options = {})
    tag_start = []
    tag_start << "<#{tag.to_s}"
    options.each{|k, v| tag_start << "#{k.to_s}=#{quote(v.to_s)}"}
    store tag_start.join(' ') + '>'
    increment_level
    yield if block_given?
    decrement_level
    store("</#{tag.to_s}>")
  end

  def class_from_options(options)
    klass = []
    klass << "grid_" + options.delete(:width).to_s if options[:width]
    klass << "prefix_" + options.delete(:prefix).to_s if options[:prefix] && !options[:prefix] == 0
    klass << "suffix_" + options.delete(:suffix).to_s if options[:suffix] && !options[:suffix] == 0
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