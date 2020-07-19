module ConfigurableClass
  def configure(method = :config, data)
    raise ArgumentError, "config data must be like a Hash" unless data.is_a? Hash

    accrs = data.inject({}) do |h, (k, v)|
      sclass = Struct.new *v.keys.map(&:to_sym)
      rclass = const_set k.capitalize, Class.new(sclass)
      
      h.merge k.to_sym => rclass.new(*v.values)
    end

    method_value = Struct.new(*accrs.keys).new(*accrs.values)

    define_method method do
      method_value
    end
  end
end
