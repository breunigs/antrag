module MotionsHelper
  def render_motion_form(form, data)
    s = ""
    data[:fields].each do |group|
      s << "<b>#{group[:group]}</b><br/>"
      group[:fields].each do |field|
        name = "dynamic_" + field[:name].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
        s << "<div class=\"field\">"
        s << "<label for=\"#{name}\">#{field[:name]}</label>"
        case field[:type]
          when :integer then s << number_field_tag(name, "0")
          when :float   then s << number_field_tag(name, "0.0")
          when :text    then s << text_area_tag(name, "", :placeholder => field[:placeholder])
          when :string  then s << text_field_tag(name, "", :placeholder => field[:placeholder])
          when :date    then s << date_select(name, "Wtf")
          else raise "Field type is unimplemented: #{field[:type]}"
        end
        s << "<p>#{field[:info]}</p>" if field[:info]
        s << gen_autocomplete(name, field[:autocomplete])
        s << "</div>"
      end
      s << "<br/>"
    end

    s.html_safe
  end

  def gen_autocomplete(name, klass)
    t = Fachschaft.all.map { |fs| "Fachschaft #{fs.name}" } if klass == :Fachschaft
    raise "No autocompleter available for #{klass}" if t.nil? && !klass.nil?
    return "" unless t
    t.map! { |x| '"' + escape_javascript(x) + '"' }
    "<script>
      $(document).ready(function () {
        console.log($(\"##{name}\"));
        $(\"##{name}\").autocomplete({
          source:  [#{t.join(", ")}]
        });
      });
      </script>"
  end
end
