require 'spec_helper'

describe "dreams/_form.html.erb" do
  it "renders dream form" do
    assign(:dream, Dream.new)
    render
    form_parameters = {
        method: 'post',
        action: dreams_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'dream[title]', type: 'text')
      expect(form).to have_selector('textarea', name: 'dream[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
