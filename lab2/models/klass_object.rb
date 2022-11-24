class KlassObject

  def initialize(*attributes)
    attributes.each do |method, value|
      instance_variable_set "@#{method}", value
    end
  end

  class << self
    # Calls attr_reader for given attributes list
    def set_attr_reader!(*attributes_list)
      class_exec do
        attr_reader(*attributes_list)
      end
    end
  end

end
