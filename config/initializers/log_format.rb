# coding: utf-8
ActiveSupport::BufferedLogger.class_eval do
  SEVERITIES = self::Severity.constants.inject({}){ |val, con| val[eval("self::#{con}")] = con; val }
  
  # ログ出力メソッドを改造
  def add_with_format(severity, message = nil, progname = nil, &block)
    # 例外オブジェクトはスタックトレースを表示
    if message.kind_of?(Exception)
      ex = message
      message = "#{ex.class.name}: #{ex.message}\n"
      if ex.backtrace
        ex.backtrace.each do |line|
          message += "\t#{line}\n"
        end
      end
    end
    # ログの出力フォーマットを変更
    add_without_format(severity, nil) { "%s [%s] %s" % [Time.now.to_s(:db), SEVERITIES[severity], message] }
  end
  alias_method_chain :add, :format
end
