#require 'wizard_steps/step'

module ChildrenCreation
  module Steps
    class ReviewAnswers < WizardSteps::Step
      def answers_by_step
        @answers_by_step ||= @wizard.reviewable_answers_by_step
      end
    end
  end
end
