require 'wizard_steps/wizard/base'

module ChildrenCreation
  class Wizard < WizardSteps::Wizard::Base
    self.steps = [
      Steps::PersonalDetails,
      Steps::ReviewAnswers,
    ].freeze

  private

    def do_complete
      Child.create!(
        first_name: @store.data["first_name"],
        last_name: @store.data["last_name"],
        date_of_birth: @store.data["date_of_birth"],
        gender: @store.data["gender"],
      )
    end
  end
end
