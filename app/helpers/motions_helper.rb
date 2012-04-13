# encoding: utf-8

module MotionsHelper
  def render_motion_form(form, data, count, check)
    s = ""
    data[:fields].each do |group|
      # create main content group
      s << %(<div class="step" data-step="#{count}" data-check="#{check}">)
      s << %(<h3>#{group[:group]}</h3>)
      group[:fields].each do |field|
        name_clean = field[:name].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
        name = "dynamic[#{name_clean}]"
        s << %(<div class="field">)
        s << %(<label for="#{name}">#{field[:name]}</label>)
        css = field[:optional] ? "" : "required"
        v = params[:dynamic][name_clean] if params && params[:dynamic]
        case field[:type]
          when :integer then s << number_field_tag(name, v ? v: "0",   :class => css)
          when :float   then s << number_field_tag(name, v ? v: "0.0", :class => css)
          when :text    then s << text_area_tag(   name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :string  then s << text_field_tag(  name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :date    then s << date_select("dynamic", name_clean, :default => get_date_from_params(name_clean), :class => css)
          else raise "Field type is unimplemented: #{field[:type]}"
        end
        s << "<p>#{field[:info]}</p>" if field[:info]
        s << gen_autocomplete(name, field[:autocomplete])
        s << "</div>"
      end
      s << next_button
      s << "</div>"

      # create folded summary
      s << %(<div class="folded" data-step="#{count}" data-check="#{check}">)
      s << (group[:summary] || group[:group])
      s << %(</div>)

      count += 1
    end

    s.html_safe
  end

    #~ <div class="step" data-step="3" data-check="1=<%=name[:finanz]%>&2=<%=name[:orientierung]%>">
        #~ <%= render_motion_form(f, MOTION_ORIENTIERUNG, 3, "1=#{name[:finanz]}&2=#{name[:orientierung]}") %>
        #~ <a class="button nextstep primary">Nächster Schritt</a>
    #~ </div>
#~
    #~ <div class="folded" data-step="3" data-check="1=<%=name[:finanz]%>">
      #~ Antragsdetails
    #~ </div>


  private

  def get_date_from_params(name)
    x = begin
      d_y = params[:dynamic][name + "(1i)"].to_i
      d_m = params[:dynamic][name + "(2i)"].to_i
      d_d = params[:dynamic][name + "(3i)"].to_i
      Date.new(d_y, d_m, d_d)
    rescue
      Date.today
    end
    # puts x.to_s
    x
  end

  def gen_autocomplete(name, klass)
    t = Fachschaft.all.map { |fs| "Fachschaft #{fs.name}" } if klass == :Fachschaft
    raise "No autocompleter available for #{klass}" if t.nil? && !klass.nil?
    return "" unless t
    t.map! { |x| '"' + escape_javascript(x) + '"' }
    name = name.gsub(/[\[\]]/, "_").gsub(/_$/, "")
    "<script>
      $(document).ready(function () {
        console.log($(\"##{name}\"));
        $(\"##{name}\").autocomplete({
          source:  [#{t.join(", ")}]
        });
      });
      </script>"
  end

  def next_button
    '<button class="button nextstep primary">Nächster Schritt</button>'
  end
end
