#require 'wizard_steps/step'

module ChildrenCreation
  module Steps
    class PersonalDetails < WizardSteps::Step
      include ActiveRecord::AttributeAssignment

      attribute :first_name, :string
      attribute :last_name, :string
      attribute :date_of_birth, :date
      attribute :gender, :string

      validates :first_name, :last_name, :date_of_birth, :gender, presence: true

      def reviewable_answers
        {
          "name" => "#{first_name} #{last_name}",
          "date_of_birth" => date_of_birth,
          "gender" => I18n.t(gender, scope: "enums.gender"),
        }
      end
    end
  end
end
