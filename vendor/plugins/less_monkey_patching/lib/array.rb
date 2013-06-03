class Array




    def to_options(options = {})
      id = options[:id] || :id
      name = options[:name] || :name
      selected = options[:selected] || nil
      s = ''
      s << '<option></option>' if options[:include_blank]
      s << options[:extras] if options[:extras]
      def selected? selected, item
        if selected.is_a?(Array)
          item.in? selected
        else
          item == selected
        end
      end
      each do |a|  
        case a.class.to_s
        when 'Array'
          s << "<option value=\"#{a[1]}\"#{' selected="selected"' if selected? selected, a[1]}>#{a[0]}</option>\n"
        when 'String'
          s << "<option value=\"#{a}\"#{' selected="selected"' if selected? selected, a}>#{a}</option>\n"
        else
          if a.is_a? ActiveRecord::Base
            s << "<option value=\"#{a.send id}\"#{' selected="selected"' if selected? selected, a.send(id)}>#{a.send(name)}</option>\n"
          else
            raise "Type not supported: #{a.class}"
          end
        end
      end
      s
    end


    def to_select(object, method, options = {})
      s = ''
      clas = options[:class] || '' 
      options.symbolize_keys!
      if options[:html]
        options[:html].each_pair{|k,v| s << " #{k}=\"#{v}\""} 
        multiple = options[:html][:multiple]
      else
        multiple = false
      end
      <<-SEL
  <select name="#{object}[#{method}]#{'[]' if multiple}" id="#{object}_#{method}"#{s} class="#{clas}">
      #{self.to_options(options)}
  </select>
  SEL
    end
  
  def to_csv
    s = ''
    self.each do |a|
      next unless a.is_a? Array
      s << a.map{|i| i.to_s.gsub(',', '')}.join(',') << "\n"
    end
    s
  end
  
  
  
  def rand
     self[Object.send('rand', size)]
  end
  
  
  
  
  def else_each zero, &proc
    if size > 0
      each &proc
    else
      zero.call
    end
  end



  def half first_half
    offset = size % 2 == 1 ? 1 : 0
    mid = (size/2 ) + offset
    if first_half
      s = 0
      e = mid
    else
      s = mid
      e = size
    end
    self[s, e]
  end


  
  
end
