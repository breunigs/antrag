# encoding: utf-8

MAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
VOTE_REGEX = /^+|-|o$/
MAX_ATTACHMENT_SIZE = 5.megabytes

MAX_REFERAT_FINANZ_BUDGET = 250.0

GROUPS = {:finanzen => "finanzen", :root => "root" }

REMOTE_BASE = "https://antrag.fsk.uni-heidelberg.de"

MAIL_FINANZ = "stefan+FSKDBG_finanz@mathphys.fsk.uni-heidelberg.de"
MAIL_FROM = "antrag@fsk.uni-heidelberg.de"
