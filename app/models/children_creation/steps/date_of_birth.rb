module ChildrenCreation
  module Steps
    class DateOfBirth < WizardSteps::Step
      include ActiveRecord::AttributeAssignment

      attribute :date_of_birth, :date

      validates :date_of_birth, presence: true

      def reviewable_answers
        {
          "date_of_birth" => date_of_birth,
        }
      end
    end
  end
end
