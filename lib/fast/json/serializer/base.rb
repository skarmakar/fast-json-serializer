require 'oj'
require 'active_record'
require_relative 'attr'

module Fast
  module Json
    module Serializer
      class Base
        attr_accessor :query

        class << self
          def set_id(attr_name)
            @id_column = attr_name.to_s
          end

          # if set_type is not defined, it will return flat result, ie, not fast json api format
          def set_type(attr_name)
            @resource_type = attr_name.to_s
          end

          def attributes(*attr_names)
            attr_names.each { |attr_name| attribute(attr_name) }
          end

          def attribute(attr_name, options = {}, &block)
            @serializable_attributes ||= []
            fast_attr = Fast::Json::Serializer::Attr.new(attr_name.to_s, options, &block)
            @serializable_attributes.append(fast_attr)
          end
        end

        def initialize(query)
          @query = (query.is_a?(String) ? query : query.to_sql).squish
        end

        # https://www.rubydoc.info/gems/pg/PG/Result
        def pg_result
          @pg_result ||= ActiveRecord::Base.connection.execute(query)
        end

        def serializable_hash(data_only: false)
          resource_type = self.class.instance_variable_get('@resource_type')
          serializable_attributes = self.class.instance_variable_get('@serializable_attributes')
          id_key = self.class.instance_variable_get('@id_column') || 'id'

          array_of_hash = pg_result.collect do |hash|
            build_formatted_hash(hash, resource_type, serializable_attributes, id_key)
          end

          return array_of_hash if data_only || !resource_type

          { 'data' => array_of_hash }
        end

        def build_formatted_hash(hash, resource_type, serializable_attributes, id_key)
          attributes = {}.tap do |h|
            serializable_attributes.collect do |fast_attr|
              h[fast_attr.name] = fast_attr.calc_value(self, hash)
            end
          end

          return attributes unless resource_type

          {
            'id' => hash[id_key],
            'type' => resource_type,
            'attributes' => attributes
          }
        end

        def serialized_json
          Oj.dump(serializable_hash)
        end
      end
    end
  end
end
