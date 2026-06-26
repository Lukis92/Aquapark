FactoryBot.define do
  factory :news do
    title   { 'Nowy wpis' }
    content { 'Długi opis wpisu' }
    association :person, factory: :trainer

    after(:build) do |news|
      news.scope = ['public'] unless news.scope.present?
      unless news.person&.persisted?
        trainer = create(:trainer)
        news.person    = trainer
        news.person_id = trainer.id
      end
    end
  end
end
