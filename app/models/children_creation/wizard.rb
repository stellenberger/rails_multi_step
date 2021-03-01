require 'wizard_steps/base'

module ChildrenCreation
  class Wizard < WizardSteps::Base
    self.steps = [
      Steps::Name,
      Steps::DateOfBirth,
      Steps::Gender,
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
