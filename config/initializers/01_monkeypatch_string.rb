class String
  def field_cleanup
    self.gsub("&shy;", "").gsub(/[^a-z0-9]+/i, "_")
  end
end
