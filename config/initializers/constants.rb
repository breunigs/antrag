# encoding: utf-8

MAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
VOTE_REGEX = /^+|-|o$/
MAX_ATTACHMENT_SIZE = 5.megabytes

GROUPS = {:finanzen => "finanzen", :root => "root" }


MOTION_ORIENTIERUNG = {
  :fields => [
    { :group => "zur Veranstaltung", :fields => [
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


MOTION_VORTRAG = {
  :fields => [
    { :group => "zur Veranstaltung", :fields => [
      { :name => "Veranstalter", :placeholder => "z.B. Fachschaft", :autocomplete => :Fachschaft, :type => :string },
      { :name => "Ort", :type => :string },
      { :name => "Datum", :type => :date },
      { :name => "Eintrittsgelder", :type => :integer },
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
