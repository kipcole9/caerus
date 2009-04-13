module OpenFlashChart

  class Point < Base
    attr_accessor :value, :colour, :tip
    
    def initialize(value, tip = "#val#", colour = "#000000")
      @value = value
      @tip = tip
      @colour = colour
    end
  end

end

# { "top": 5, "colour": "#000000", "tip": "Spoon {#val#}" }
#{ }"values": [2, {"tip": "This is my tip", "colour": "#FFFFFF", "top": 20}, 100, 25, 13]
