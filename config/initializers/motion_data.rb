# encoding: utf-8

MOTION_ORIENTIERUNG = {
  :ident => "Finanzantrag/Orientierungsveranstaltung", # rename in Kingslanding and motion model, too
  :groups => [
    { :group => "zur Veranstaltung", :summary => "Veranstaltungsdetails", :fields => [
      { :name => "Veranstalter", :placeholder => "z.B. Fachschaft", :autocomplete => :Fachschaft, :type => :string},
      { :name => "Ort", :type => :string },
      { :name => "Datum", :type => :date },
      { :name => "Thema", :type => :string },
      { :name => "Teilnehmer", :type => :integer },]
    },
    { :group => "Kosten", :fields => [
      { :name => "Kosten&shy;zusam&shy;men&shy;setzung", :type => :text, :placeholder => "z.B. 123€ für Kuchen, 456€ für Kaffeepulver, 78€ für Lutscher…" },
      { :name => "Gesamtkosten", :type => :float },
      { :name => "Eigenbeteiligung", :type => :float },
      { :name => "beantragter Zuschuss", :type => :float, :is_fin_expected_amount => true }]
    }
  ]
}

MOTION_REISEKOSTEN = {
  :ident => "Finanzantrag/Reisekostenantrag",  # rename in Kingslanding and motion model, too
  :groups => [
    { :group => "Details zur Reise", :fields => [
      { :name => "Zweck", :type => :string, :placeholder => "z.B. Fachvortrag, Fachschaftentreffen, …", :info => "Salopp forumliert: „was ist da?“. Nur wenn aus dem Namen der Veranstaltung nicht hervorgeht muss dies erläutert werden." },
      { :name => "Ort", :type => :string, :placeholder => "z.B. Berlin, Timbuktu, Erbach…" },
      { :name => "Hinfahrt am", :type => :date },
      { :name => "Rückfahrt am", :type => :date },
    ]},
    { :group => "Kosten", :fields => [
      { :name => "Kosten Bahnfahrt", :type => :float, :info => "Kosten der Hin- und Rückfahrt mit der Bahn pro Person, zweite Klasse, ohne Bahncard. Das ist der Preis <a href=\"http://www.bahn.de\">den bahn.de anzeigt</a>, wenn man keine besonderen Eingaben macht. Diese Angabe ist <i>immer</i> erforderlich." },
      { :name => "Verkehrsmittel", :type => :select, :values => [
          { :name => "Bahn", :info => "in der Regel nur bis zu 3 Personen" },
          { :name => "Auto", :info => "bitte zusätzliche Felder zur Anreise mit dem Auto beachten" },
          { :name => "Sonstiges", :info => "Kosten und Details bitte im Begründungstext auf der letzten Seite angeben."}
        ]
      },
      { :name => "Fahrtweg in km", :type => :integer, :optional => true, :info => "Nur bei Anreise mit dem Auto. Für Hin- und Rückfahrt. <a href=\"http://map.project-osrm.org/\">Ein Routenplaner hilft</a>." },
      { :name => "Automiete", :type => :float, :optional => true, :info => "Nur bei Anreise mit dem Auto. Falls ein Auto gemietet werden muss, hier die Gesamtkosten für die Miete (inkl. Kilometerpauschale, ohne Treibstoff)." },
      { :name => "Treibstoffkosten", :type => :float, :optional => true, :info => "Nur bei Anreise mit dem Auto. Geschätzte Treibstoffkosten für Hin- und Rückfahrt." }
      #{ :name => "Kosten insgesamt", :type => :float, :info => "" }
    ]},
    { :group => "Anreisende Personen", :fields => [
      { :name => "Name",      :index => "0", :type => :string, :info => "Vollständiger Name, so wie er auf dem Personalausweis zu finden ist." },
      { :name => "Bahncard",  :index => "0", :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50" ]},
      (1..14).map do |i|
        [{ :name => "Name",      :index => i.to_s, :type => :string, :optional => true},
         { :name => "Bahncard",  :index => i.to_s, :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50"], :optional => true}]
      end,
      { :name => "Name",      :index => "15", :type => :string, :optional => true},
      { :name => "Bahncard",  :index => "15", :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50"], :info => "Wenn ihr noch mehr seid, gebt die anderen bitte im Freitext an.", :optional => true }

    ].flatten}
  ]
}


MOTION_VORTRAG = {
  :ident => "Finanzantrag/Vortrag (Honorar)",  # rename in Kingslanding and motion model, too
  :groups => [
    { :group => "zur Veranstaltung", :summary => "Veranstaltungsdetails", :fields => [
      { :name => "Veranstalter", :placeholder => "z.B. Fachschaft", :autocomplete => :Fachschaft, :type => :string },
      { :name => "Ort", :type => :string },
      { :name => "Datum", :type => :date },
      { :name => "Eintrittsgelder", :type => :integer, :info => "Wenn Eintrittsgelder erhoben werden, gib hier bitte den Maximalpreis pro Person an. Ist der Eintritt kostenlos, lasse die 0 stehen." },
      { :name => "Thema", :type => :string }]
    },
    { :group => "zum/zur Vortragenden", :fields => [
      { :name => "Privatanschrift Vortragender", :type => :text },
      { :name => "Abreiseort", :type => :string, :placeholder => "z.B. Heimatstadt des/der Vortragenden" },
      { :name => "Verkehrsmittel", :type => :string, :placeholder => "z.B. Auto, Bahn…" },
      { :name => "Fahrtkosten", :type => :float, :is_fin_expected_amount => true },
      { :name => "Honorarhöhe", :type => :float, :is_fin_expected_amount => true },
      { :name => "Bankverbindung", :type => :string, :placeholder => "Inhaber, Kto-Nr., BLZ (oder IBAN und BIC)" }]
    }
  ]
}

ALL_MOTIONS = [MOTION_VORTRAG, MOTION_REISEKOSTEN, MOTION_ORIENTIERUNG]

# first is the JS identifier, second the name without the dynamic[]
# boilerplate and the last one is how the field’s name attribute should
# be. Forth is the kind identifier used in the name field.
def get_identifiers_for_field(field, constant)
  g = constant[:ident].field_cleanup
  name_clean = field[:name].gsub("&shy;", "").field_cleanup
  name = "dynamic[#{g}][#{name_clean}]"
  name << "[#{field[:index]}]" if field[:index]
  id = name.field_cleanup
  return id, name_clean, name, g
end

# this checks that there are no duplicate fields per form.
all_ids = []
all_names = []
ALL_MOTIONS.each do |m|
  m[:groups].each do |group|
    group[:fields].each do |field|
        id, name_clean, name = get_identifiers_for_field(field, m)
        raise "ID #{id} is duplicate for motion constants. (name = #{name})" if all_ids.include?(id)
        raise "Name #{id} is duplicate for motion constants." if all_names.include?(name)
        all_ids << id
        all_names << name
    end
  end
end

