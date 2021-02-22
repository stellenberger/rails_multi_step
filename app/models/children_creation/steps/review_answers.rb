require 'wizard_steps/wizard/step'

module ChildrenCreation
  module Steps
    class ReviewAnswers < WizardSteps::Wizard::Step
      def answers_by_step
        @answers_by_step ||= @wizard.reviewable_answers_by_step
      end
    end
  end
end
