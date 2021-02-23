module ApplicationHelper
  def back_link(path = :back, text: "Back", **options)
    render GovukComponent::BackLink.new(
      text: text,
      href: path,
      **options,
    )
  end

  def link_to_change_answer(placement_id, step)
    link_to(placement_diary_step_path(placement_id, step.key), { class: "govuk-link" }) do
      "Change"
    end
  end
end
