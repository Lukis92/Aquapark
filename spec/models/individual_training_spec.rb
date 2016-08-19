# == Schema Information
#
# Table name: individual_trainings
#
#  id               :integer          not null, primary key
#  date_of_training :date             not null
#  client_id        :integer
#  trainer_id       :integer
#  start_on         :time             not null
#  end_on           :time             not null
#  training_cost_id :integer
#

describe IndividualTraining, 'associations' do
  it { is_expected.to belong_to :trainer }
  it { is_expected.to belong_to :client }
  it { is_expected.to belong_to :training_cost }
end

describe IndividualTraining, 'column_specifications' do
  it { is_expected.to have_db_column(:date_of_training).of_type(:date).with_options(null: false) }
  it { is_expected.to have_db_column(:client_id).of_type(:integer) }
  it { is_expected.to have_db_column(:trainer_id).of_type(:integer) }
  it { is_expected.to have_db_column(:start_on).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:end_on).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:training_cost_id).of_type(:integer) }
end

describe IndividualTraining, 'validations' do
  it { is_expected.to validate_presence_of :start_on }
  it { is_expected.to validate_presence_of :end_on }
  it { is_expected.to validate_presence_of :date_of_training }
  it { is_expected.to validate_presence_of :training_cost_id }
end

describe IndividualTraining, 'methods' do
  describe '#date_and_start_on_validation' do
    let(:individual_training) { build :individual_training, date_of_training: '2016-08-15' }
    let(:ind2) { build :individual_training, date_of_training: Date.today, start_on: Time.now - 1.hour, end_on: Time.now }
    context 'when date of training is before today' do
      it 'raises an error' do
        expect(individual_training.valid?).to be_falsey
        expect(individual_training.errors.count).to eq 1
        expect(individual_training.errors[:base])
          .to eq(['Nie możesz ustalać terminu treningu wcześniej niż dzień dzisiejszy.'])
      end
    end
    context 'when start_on is/(not) before Time now' do
      it 'raises an error' do
        expect(ind2.valid?).to be_falsey
        expect(ind2.errors.count).to eq 1
        expect(ind2.errors[:base])
          .to eq ['Godzina dzisiejszego treningu jest wcześniejsza niż obecny czas.']
      end
    end
  end

  describe '#client_free_time_validation' do
    let(:work_schedule) { create :work_schedule }
    let(:wsch2) { create :wch2 }
    let(:ind2){ build(:ind, trainer_id: wsch2[:person_id]).tap {|e| p e.valid?; p e.errors}}
    let(:individual_training) { build(:ind2, trainer_id: work_schedule[:person_id]).tap {|e| p e.valid?; p e.errors}}

    context 'when training is during another training' do
      it 'raises an error' do
        expect(individual_training.valid?).to be_truthy
        # expect(ind2.valid?).to be_truthy
        # expect(ind2.errors.count).to eq 1
        # expect(ind2.errors[:base]).to eq(['Masz w tym czasie inny trening.'])
      end
    end
  end

  describe '#date_of_training_validation' do
    let(:work_schedule) { create :work_schedule }
    let(:individual_training) { build :individual_training, trainer_id: work_schedule[:person_id] }
    let(:ind2) do
      build :individual_training,
            trainer_id: work_schedule[:person_id],
            date_of_training: Date.today + 1.day,
            start_on: Time.now - 1.hour,
            end_on: Time.now
    end
    date = Date.today.next_week.advance(days: 0)
    context 'when training is outside of work schedule(same day, diff hours)' do
      it 'raises an error' do
        expect(work_schedule.valid?).to be_truthy
        expect(individual_training.valid?).to be_falsey
        expect(individual_training.errors.count).to eq 1
        expect(individual_training.errors[:base]).to eq(['Trening jest poza grafikiem pracy trenera.'])
      end
    end
    context 'when training is on free trainer day' do
      it 'raises an error' do
        expect(work_schedule.valid?).to be_truthy
        expect(ind2.valid?).to be_falsey
        expect(ind2.errors.count).to eq 1
        expect(ind2.errors[:base]).to eq(['Trener w tym dniu nie pracuje.'])
      end
    end
  end

end
