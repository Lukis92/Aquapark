require 'rails_helper'

RSpec.describe Backend::ActivitiesController, type: :controller do
  let(:person) { create :person }

  before { sign_in person}

  describe 'GET #index' do
    let(:manager) { create :manager}
    subject { get :index, id: manager.id }

    it_behaves_like 'template rendering action', :show
  end
end
