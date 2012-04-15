# encoding: utf-8

module MotionsHelper
  def render_motion_form(form, data, count, check)
    s = ""
    data[:groups].each do |group|
      # create main content group
      s << %(<div class="step" data-step="#{count}" data-check="#{check}">)
      s << %(<h3>#{count}. #{group[:group]}</h3>)
      group[:fields].each do |field|
        id, name_clean, name, gr = get_identifiers_for_field(field, data)
        s << %(<div class="field">)
        s << %(<label for="#{name}">#{field[:name]}</label>)
        css = field[:optional] ? "" : "required"
        v = params[:dynamic][gr][name_clean] if params && params[:dynamic] && params[:dynamic][gr]
        case field[:type]
          when :integer then s << number_field_tag(name, v ? v: "0",   :class => css)
          when :float   then s << number_field_tag(name, v ? v: "0.0", :class => css)
          when :text    then s << text_area_tag(   name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :string  then s << text_field_tag(  name, v ? v: "",    :placeholder => field[:placeholder], :class => css)
          when :date    then s << date_select(name, "", :default => get_date_from_params(field, data), :class => css)
          when :select  then
            s << select(name, "", get_select_values(field), :class => css)
            s << get_js_for_dynamic_select_info(field, data)
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

  # see config/initializers/motion_data.rb
  # def get_identifiers_for_field(field, constant)

  def get_select_values(field)
    field[:values].map do |f|
      f.is_a?(String) ? f : f[:name]
    end
  end

  def get_js_for_dynamic_select_info(field, constant)
    id, name_clean, name = get_identifiers_for_field(field, constant)
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

  def get_date_from_params(field, constant)
    id, name_clean, name, const_id = get_identifiers_for_field(field, constant)
    x = begin
      d_y = params[:dynamic][const_id][name_clean]["(1i)"].to_i
      d_m = params[:dynamic][const_id][name_clean]["(2i)"].to_i
      d_d = params[:dynamic][const_id][name_clean]["(3i)"].to_i
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
    name = name.field_cleanup.gsub(/_$/, "")
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
