# encoding: utf-8

module MotionsHelper
  def render_motion_form(form, data, count, check)
    s = ""
    data[:groups].each do |group|
      # create main content group
      s << %(<div class="step" data-step="#{count}" data-check="#{check}">)
      s << %(<h3>#{count}. #{group[:group]}</h3>)
      group[:fields].each do |field|
        id, name_clean, name, gr = get_identifiers_for_field(field, group)
        s << %(<div class="field">)
        s << %(<label for="#{name}">#{field[:name]}</label>)
        css = field[:optional] ? "" : "required"
        v = params[:dynamic][gr][name_clean] if params && params[:dynamic] && params[:dynamic][gr]
        case field[:type]
          when :integer then s << number_field_tag(name, v ? v: "0",   :class => css)
          when :float   then s << number_field_tag(name, v ? v: "0.0", :class => css)
          when :text    then s << text_area_tag(   name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :string  then s << text_field_tag(  name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :date    then s << date_select(name, "", :default => get_date_from_params(field, group), :class => css)
          when :select  then
            s << select(name, "", get_select_values(field), :class => css)
            s << get_js_for_dynamic_select_info(field, group)
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
      s << "#{count}. "+ (group[:summary] || group[:group])
      s << %(</div>)

      count += 1
    end

    s.html_safe
  end

  private

  # first is the JS identifier, second the name without the dynamic[]
  # boilerplate and the last one is how the field’s name attribute should
  # be. Forth is the group identifier used in the name field.
  def get_identifiers_for_field(field, group)
    g = group[:ident].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
    a = (field[:name_append] || "").gsub(/[^a-z0-9]/i, "_")
    name_clean = field[:name].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
    name = "dynamic[#{g}][#{name_clean}]#{field[:name_append]}"
    id = name.gsub(/[^a-z0-9]+/i, "_")
    return id, name_clean, name, g
  end

  def get_select_values(field)
    field[:values].map do |f|
      f.is_a?(String) ? f : f[:name]
    end
  end

  def get_js_for_dynamic_select_info(field, group)
    id, name_clean, name = get_identifiers_for_field(field, group)
    data = field[:values].map do |f|
      f.is_a?(String) || f[:info].blank? \
        ? nil \
        : %("#{escape_javascript(f[:name])}": "#{escape_javascript(f[:info])}")
    end.compact
    return "" if data.empty?
    %(<label id="#{id}_info_box" class="notice"></p>
    <script>
      $(document).ready(function(){
        $("##{id}").change(function () {
          var data = {#{data.join(", ")}}
          var nfo = $("##{id}_info_box");
          $("##{id} option:selected").each(function () {
            nfo.text(data[$(this).text()]);
          });
        }).trigger('change');
      });
    </script>)
  end

  def get_date_from_params(field, group)
    id, name_clean, name, group = get_identifiers_for_field(field, group)
    x = begin
      d_y = params[:dynamic][group][name_clean + "(1i)"].to_i
      d_m = params[:dynamic][group][name_clean + "(2i)"].to_i
      d_d = params[:dynamic][group][name_clean + "(3i)"].to_i
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
        //console.log($(\"##{name}\"));
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
