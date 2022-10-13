module Fast
  module Json
    module Serializer
      class Attr
        attr_accessor :name, :block, :column_name, :format
        
        # options can be  
        #  - column_name, from which column to get value
        #  - format, method to be called on the value
        def initialize(name, options, &block)
          @name = name
          @block = block
          @column_name = options[:column_name]&.to_s
          @format = options[:format]
        end
    
        def calc_value(serializer, hash)
          return block.call(serializer, hash) if block
          
          value = hash[column_name || name]
          format ? value.send(format) : value
        end
      end
    end
  end
end
