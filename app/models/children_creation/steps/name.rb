module ChildrenCreation
  module Steps
    class Name < WizardSteps::Step

      attribute :first_name, :string
      attribute :last_name, :string

      validates :first_name, :last_name, presence: true

      def reviewable_answers
        {
          "name" => "#{first_name} #{last_name}",
        }
      end
    end
  end
end
