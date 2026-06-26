require 'rails_helper'

describe Notification, 'associations' do
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to(:actor).class_name('Person').optional }
  it { is_expected.to belong_to(:notifiable).optional }
end

describe Notification, 'column specifications' do
  it { is_expected.to have_db_column(:kind).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:message).of_type(:text).with_options(null: false) }
  it { is_expected.to have_db_column(:person_id).of_type(:integer).with_options(null: false) }
  it { is_expected.to have_db_column(:read_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:actor_id).of_type(:integer) }
  it { is_expected.to have_db_column(:notifiable_id).of_type(:integer) }
  it { is_expected.to have_db_column(:notifiable_type).of_type(:string) }

  it { is_expected.to have_db_index(:person_id) }
  it { is_expected.to have_db_index(:read_at) }
end

describe Notification, 'scopes' do
  let!(:unread) { create(:notification) }
  let!(:read)   { create(:notification, read_at: Time.current) }

  describe '.unread' do
    it 'returns only notifications without read_at' do
      expect(Notification.unread).to include(unread)
      expect(Notification.unread).not_to include(read)
    end
  end

  describe '.recent' do
    it 'orders notifications by created_at desc' do
      older = create(:notification, created_at: 2.days.ago)
      newer = create(:notification, created_at: 1.day.ago)
      recent_list = Notification.recent.to_a
      expect(recent_list.index(newer)).to be < recent_list.index(older)
    end
  end
end

describe Notification, '.notify' do
  let(:person) { create(:trainer) }

  it 'creates a notification record' do
    expect {
      Notification.notify(person: person, kind: 'vacation_accepted', message: 'Urlop zaakceptowany.')
    }.to change(Notification, :count).by(1)
  end

  it 'assigns the correct attributes' do
    notification = Notification.notify(person: person, kind: 'ticket_purchased', message: 'Bilet zakupiony.')
    expect(notification.kind).to eq 'ticket_purchased'
    expect(notification.message).to eq 'Bilet zakupiony.'
    expect(notification.person).to eq person
    expect(notification.read_at).to be_nil
  end

  it 'accepts optional actor and notifiable' do
    actor = create(:trainer)
    notification = Notification.notify(
      person: person,
      kind: 'activity_signup',
      message: 'Zapisano na zajęcia.',
      actor: actor
    )
    expect(notification.actor).to eq actor
  end
end

describe Notification, '#read?' do
  it 'returns false when read_at is nil' do
    notification = build(:notification, read_at: nil)
    expect(notification.read?).to be_falsey
  end

  it 'returns true when read_at is set' do
    notification = build(:notification, read_at: 1.hour.ago)
    expect(notification.read?).to be_truthy
  end
end

describe Notification, '#mark_as_read!' do
  let(:notification) { create(:notification, read_at: nil) }

  it 'sets read_at timestamp' do
    expect { notification.mark_as_read! }.to change { notification.read_at }.from(nil)
  end

  it 'does not update read_at if already read' do
    time = 1.hour.ago
    notification.update!(read_at: time)
    notification.mark_as_read!
    expect(notification.reload.read_at.to_i).to eq time.to_i
  end
end

describe Notification, '#icon' do
  it 'returns the correct icon for a known kind' do
    notification = build(:notification, kind: 'vacation_accepted')
    expect(notification.icon).to eq 'fa-check-circle'
  end

  it 'returns the default icon for an unknown kind' do
    notification = build(:notification, kind: 'unknown_event')
    expect(notification.icon).to eq 'fa-bell'
  end
end

describe Notification, '#css_class' do
  it 'returns the correct css class for a known kind' do
    notification = build(:notification, kind: 'vacation_rejected')
    expect(notification.css_class).to eq 'danger'
  end

  it 'returns the default css class for an unknown kind' do
    notification = build(:notification, kind: 'unknown_event')
    expect(notification.css_class).to eq 'default'
  end
end
