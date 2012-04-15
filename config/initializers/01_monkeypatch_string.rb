# encoding: utf-8

class String
  def field_cleanup
    self.gsub("&shy;", "").gsub(/[^a-z0-9]+/i, "_")
  end

  def valid_integer?
    self.to_i_magic.to_s == val.cleanup_magic
  end

  def valid_float?
    self.to_f_magic.to_s == val.cleanup_magic || valid_integer?
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
