require 'rails_helper'

RSpec.describe Backend::ActivitiesController, type: :controller do
  let(:person) { create :person }

  before { sign_in person}

  describe 'GET #index' do
    subject { get :index }

    it_behaves_like 'template rendering action', :index
  end
end
