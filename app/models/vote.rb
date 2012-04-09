class Vote < ActiveRecord::Base
  attr_accessible

  # +  == dafür
  # -  == dagegen
  # o  == Enthaltung
  validates_format_of :result, :with => VOTE_REGEX

  # allow only one vote per motion/fachschaft
  validates :fachschaft_id, :uniqueness => {:scope => :motion_id}

  belongs_to :fachschaft
  belongs_to :motion

  def result_printable
    case result
      when "+" then "Zustimmung"
      when "-" then "Ablehnung"
      when "o" then "Enthaltung"
      else raise "Invalid vote type."
    end
  end
end
