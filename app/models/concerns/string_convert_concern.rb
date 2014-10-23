module StringConvertConcern
  def self.zero_fill_number_string(value)
    ret = value
    begin
      ret = sprintf("%#0*d", DEC_DIGITS, value)
    rescue
      ret = value
    end
    return ret
  end
end
