module ChildrenCreation
  module Steps
    class Gender < WizardSteps::Step

      attribute :gender, :string

      validates :gender, presence: true

      def reviewable_answers
        {
          "gender" => gender,
        }
      end
    end
  end
end
