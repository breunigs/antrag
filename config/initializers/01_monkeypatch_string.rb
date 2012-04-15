# encoding: utf-8

class String
  def field_cleanup
    self.gsub("&shy;", "").gsub(/[^a-z0-9]+/i, "_")
  end

  def valid_integer?
    !self.cleanup_magic !~ /^\s*[0-9]+\s*$/
  end

  def valid_float?
    # http://stackoverflow.com/questions/1034418/determine-if-a-string-is-a-valid-float-value
    !self.cleanup_magic !~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
  end

  def to_f_magic
    cleanup_magic.to_f
  end

  def to_i_magic
    cleanup_magic.to_i
  end

  # prepare this string to be converted to a float/integer
  def cleanup_magic
    self.gsub(/EUR|€/, "").gsub(",", ".").strip
  end
end
