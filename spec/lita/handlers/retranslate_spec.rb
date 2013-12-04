require "spec_helper"

describe Lita::Handlers::Retranslate, lita_handler: true do
  it { routes_command("retranslate foo bar").to(:retranslate) }
end
