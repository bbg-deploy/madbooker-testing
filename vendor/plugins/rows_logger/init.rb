# Include hook code here



if PLATFORM != 'java' && false
  
ActiveRecord::ConnectionAdapters::Mysql2Adapter.class_eval do
  protected
  def count_result(result)
    result.num_rows
  end
end


ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
      protected
        def log(sql, name)
          name ||= "SQL"
          result = nil
          begin
            @instrumenter.instrument("sql.active_record",
              :sql => sql, :name => name, :connection_id => object_id) do
              result = yield
            end
            log_info(sql, name, 0, result)
          rescue Exception => e
            message = "#{e.class.name}: #{e.message}: #{sql}"
            @logger.debug message if @logger
            raise translate_exception(e, message)
          end
          return
          
          if block_given?
            if @logger and @logger.level <= Logger::INFO
              result = nil
              seconds = Benchmark.realtime { result = yield }
              #@runtime += seconds
              log_info(sql, name, seconds, result)
              result
            else
              yield
            end
          else
            log_info(sql, name, 0)
            nil
          end
        rescue Exception => e
          # Log message and raise exception.
          # Set last_verfication to 0, so that connection gets verified
          # upon reentering the request loop
          @last_verification = 0
          message = "#{e.class.name}: #{e.message}: #{sql}"
          log_info(message, name, 0)
          raise ActiveRecord::StatementInvalid, message
        end

        def log_info(sql, name, runtime, result = nil)
          return unless @logger

          @logger.debug(
            #format_log_entry(
              "#{name.nil? ? "SQL" : name} (#{sprintf("%f", runtime)})#{log_result_info(result)} #{sql}"
              #sql.gsub(/ +/, " ")
            #)
          )
        end

        def log_result_info(result)
          return nil
          return nil if result.nil? or !respond_to?(:count_result)

          count = count_result(result) rescue '?' or return nil
          unit  = (count == 1) ? 'Row' : 'Rows'
          " (%s %s)" % [count, unit]
        end
end



end