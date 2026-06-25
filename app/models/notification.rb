class Notification < ApplicationRecord
  belongs_to :person
  belongs_to :actor, class_name: 'Person', optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread,  -> { where(read_at: nil) }
  scope :recent,  -> { order(created_at: :desc) }

  ICONS = {
    'vacation_accepted'            => 'fa-check-circle',
    'vacation_rejected'            => 'fa-times-circle',
    'work_schedule_added'          => 'fa-calendar-plus-o',
    'work_schedule_updated'        => 'fa-calendar',
    'work_schedule_removed'        => 'fa-calendar-times-o',
    'individual_training_assigned' => 'fa-child',
    'individual_training_cancelled'=> 'fa-ban',
    'activity_accepted'            => 'fa-check-square-o',
    'activity_rejected'            => 'fa-minus-square-o',
    'activity_signup'              => 'fa-user-plus',
    'activity_resign'              => 'fa-user-times',
    'ticket_purchased'             => 'fa-ticket',
  }.freeze

  CSS_CLASSES = {
    'vacation_accepted'            => 'success',
    'vacation_rejected'            => 'danger',
    'work_schedule_added'          => 'info',
    'work_schedule_updated'        => 'warning',
    'work_schedule_removed'        => 'danger',
    'individual_training_assigned' => 'success',
    'individual_training_cancelled'=> 'danger',
    'activity_accepted'            => 'success',
    'activity_rejected'            => 'warning',
    'activity_signup'              => 'info',
    'activity_resign'              => 'warning',
    'ticket_purchased'             => 'success',
  }.freeze

  def self.notify(person:, kind:, message:, actor: nil, notifiable: nil)
    create!(
      person:          person,
      kind:            kind,
      message:         message,
      actor:           actor,
      notifiable:      notifiable,
      notifiable_type: notifiable&.class&.name,
      notifiable_id:   notifiable&.id
    )
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current) unless read?
  end

  def icon
    ICONS.fetch(kind, 'fa-bell')
  end

  def css_class
    CSS_CLASSES.fetch(kind, 'default')
  end
end
