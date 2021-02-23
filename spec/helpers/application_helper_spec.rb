require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#back_link" do
    it "renders a back link with GOV.UK class names" do
      expect(back_link).to eq("<a class=\"govuk-back-link\" href=\"javascript:history.back()\">Back</a>\n")
    end
  end
end
