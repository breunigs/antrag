# encoding: utf-8

MAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
VOTE_REGEX = /^+|-|o$/
MAX_ATTACHMENT_SIZE = 5.megabytes

GROUPS = {:finanzen => "finanzen", :root => "root" }


MOTION_ORIENTIERUNG = {
  :groups => [
    { :group => "zur Veranstaltung", :ident => "gr1", :summary => "Veranstaltungsdetails", :fields => [
      { :name => "Veranstalter", :placeholder => "z.B. Fachschaft", :autocomplete => :Fachschaft, :type => :string},
      { :name => "Ort", :type => :string },
      { :name => "Datum", :type => :date },
      { :name => "Thema", :type => :string },
      { :name => "Teilnehmer", :type => :integer },]
    },
    { :group => "Kosten", :ident => "gr2", :fields => [
      { :name => "Kosten&shy;zusam&shy;men&shy;setzung", :type => :text, :placeholder => "z.B. 123€ für Kuchen, 456€ für Kaffeepulver, 78€ für Lutscher…" },
      { :name => "Gesamtkosten", :type => :float },
      { :name => "Eigenbeteiligung", :type => :float },
      { :name => "beantragter Zuschuss", :type => :float, :is_fin_expected_amount => true }]
    }
  ]
}

MOTION_REISEKOSTEN = {
  :groups => [
    { :group => "Details zur Reise", :ident => "gr3", :fields => [
      { :name => "Zweck", :type => :string, :placeholder => "z.B. Fachvortrag, Fachschaftentreffen, …", :info => "Salopp forumliert: „was ist da?“. Nur wenn aus dem Namen der Veranstaltung nicht hervorgeht muss dies erläutert werden." },
      { :name => "Ort", :type => :string, :placeholder => "z.B. Berlin, Timbuktu, Erbach…" },
      { :name => "Hinfahrt am", :type => :date },
      { :name => "Rückfahrt am", :type => :date },
    ]},
    { :group => "Kosten", :ident => "gr4", :fields => [
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
    ]},
    { :group => "Anreisende Personen", :ident => "gr5", :fields => [
      { :name => "Name",      :name_append => "[0]", :type => :string, :info => "Vollständiger Name, so wie er auf dem Personalausweis zu finden ist." },
      { :name => "Bahncard",  :name_append => "[0]", :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50" ]},
      (1..14).map do |i|
        [{ :name => "Name",      :name_append => "[#{i}]", :type => :string, :optional => true},
         { :name => "Bahncard",  :name_append => "[#{i}]", :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50"], :optional => true}]
      end,
      { :name => "Name",      :name_append => "[15]", :type => :string, :optional => true},
      { :name => "Bahncard",  :name_append => "[15]", :type => :select, :values => ["keine", "BahnCard 25", "BahnCard 50"], :info => "Wenn ihr noch mehr seid, gebt die anderen bitte im Freitext an.", :optional => true }

    ].flatten}
  ]
}


MOTION_VORTRAG = {
  :groups => [
    { :group => "zur Veranstaltung", :ident => "gr6", :summary => "Veranstaltungsdetails", :fields => [
      { :name => "Veranstalter", :placeholder => "z.B. Fachschaft", :autocomplete => :Fachschaft, :type => :string },
      { :name => "Ort", :type => :string },
      { :name => "Datum", :type => :date },
      { :name => "Eintrittsgelder", :type => :integer, :info => "Wenn Eintrittsgelder erhoben werden, gib hier bitte den Maximalpreis pro Person an. Ist der Eintritt kostenlos, lasse die 0 stehen." },
      { :name => "Thema", :type => :string }]
    },
    { :group => "zum/zur Vortragenden", :ident => "gr7", :fields => [
      { :name => "Privatanschrift Vortragender", :type => :text },
      { :name => "Abreiseort", :type => :string, :placeholder => "z.B. Heimatstadt des/der Vortragenden" },
      { :name => "Verkehrsmittel", :type => :string, :placeholder => "z.B. Auto, Bahn…" },
      { :name => "Fahrtkosten", :type => :float, :is_fin_expected_amount => true },
      { :name => "Honorarhöhe", :type => :float, :is_fin_expected_amount => true },
      { :name => "Bankverbindung", :type => :string, :placeholder => "Inhaber, Kto-Nr., BLZ (oder IBAN und BIC)" }]
    }
  ]
}


# copied from motion_helper:
# debug code to ensure there are no duplicate fields
def get_identifiers_for_field(field, group)
  g = group[:ident].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
  a = (field[:name_append] || "").gsub(/[^a-z0-9]/i, "_")
  name_clean = field[:name].gsub("&shy;", "").gsub(/[^a-z0-9]/i, "_")
  name = "dynamic[#{g}][#{name_clean}]#{field[:name_append]}"
  id = name.gsub(/[^a-z0-9]+/i, "_")
  return id, name_clean, name, g
end

all_ids = []
all_names = []
[MOTION_VORTRAG, MOTION_REISEKOSTEN, MOTION_ORIENTIERUNG].each do |m|
  m[:groups].each do |group|
    group[:fields].each do |field|
        id, name_clean, name = get_identifiers_for_field(field, group)
        raise "ID #{id} is duplicate for motion constants. (name = #{name})" if all_ids.include?(id)
        raise "Name #{id} is duplicate for motion constants." if all_names.include?(name)
        all_ids << id
        all_names << name
    end
  end
end

