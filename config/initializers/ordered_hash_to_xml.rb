module ActiveSupport
  class OrderedHash < Hash
    def to_xml(column = "attribute", value = "value")
      xml = Builder::XmlMarkup.new(:indent => 2, :dasherize => false)
      xml.instruct!
      xml.flex_hash do
        self.each do |e|
          xml.data_series do
            xml.tag!(column, e[0].to_s, :type => xml_type(e[0]))
            xml.tag!(value, e[1].to_s, :type => xml_type(e[1]))
          end
        end
      end
    end
    
  private
    def xml_type(arg)
      Hash::XML_TYPE_NAMES[arg.class.name] || "string"
    end
  end
end