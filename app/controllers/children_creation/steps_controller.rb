module ChildrenCreation
  class StepsController < ApplicationController
    include WizardSteps
    self.wizard_class = ChildrenCreation::Wizard

  private

    def step_path(step = params[:id])
      children_creation_step_path(step)
    end

    def wizard_store_key
      :children_creation
    end

    def on_complete(child)
      redirect_to(new_child_placement_need_path(child.id))
    end
  end
end