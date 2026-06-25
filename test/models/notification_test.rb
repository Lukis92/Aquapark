require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # ── Notification.notify ──────────────────────────────────────────────────
  test 'notify tworzy powiadomienie' do
    assert_difference 'Notification.count', 1 do
      Notification.notify(
        person:  people(:manager),
        kind:    'ticket_purchased',
        message: 'Klient kupił bilet.'
      )
    end
  end

  test 'notify przypisuje aktora i powiązany rekord' do
    entry_type = entry_types(:bilet_jednorazowy)
    n = Notification.notify(
      person:     people(:manager),
      actor:      people(:client),
      kind:       'ticket_purchased',
      message:    'Klient kupił bilet.',
      notifiable: entry_type
    )
    assert_equal people(:client),  n.actor
    assert_equal entry_type,       n.notifiable
    assert_equal 'EntryType',      n.notifiable_type
  end

  # ── read? / mark_as_read! ────────────────────────────────────────────────
  test 'nowe powiadomienie jest nieprzeczytane' do
    n = Notification.notify(person: people(:manager), kind: 'vacation_accepted',
                            message: 'Urlop zaakceptowany.')
    assert_not n.read?
    assert_nil n.read_at
  end

  test 'mark_as_read! ustawia read_at' do
    n = Notification.notify(person: people(:manager), kind: 'vacation_accepted',
                            message: 'Urlop zaakceptowany.')
    n.mark_as_read!
    assert n.read?
    assert_not_nil n.read_at
  end

  test 'mark_as_read! nie zmienia read_at jeśli już przeczytane' do
    n = Notification.notify(person: people(:manager), kind: 'vacation_accepted',
                            message: 'Urlop zaakceptowany.')
    n.mark_as_read!
    first_read_at = n.read_at
    n.mark_as_read!
    assert_equal first_read_at, n.read_at
  end

  # ── scope :unread ─────────────────────────────────────────────────────────
  test 'scope unread zwraca tylko nieprzeczytane' do
    n = Notification.notify(person: people(:manager), kind: 'activity_signup',
                            message: 'Zapis na zajęcia.')
    assert_includes Notification.unread, n
    n.mark_as_read!
    assert_not_includes Notification.unread, n
  end

  # ── icon / css_class ─────────────────────────────────────────────────────
  test 'icon zwraca klasę Font Awesome dla danego rodzaju' do
    n = Notification.new(kind: 'vacation_accepted')
    assert_equal 'fa-check-circle', n.icon

    n.kind = 'ticket_purchased'
    assert_equal 'fa-ticket', n.icon
  end

  test 'icon zwraca domyślną ikonę dla nieznanego rodzaju' do
    n = Notification.new(kind: 'nieznany_typ')
    assert_equal 'fa-bell', n.icon
  end

  test 'css_class zwraca klasę Bootstrap dla danego rodzaju' do
    n = Notification.new(kind: 'vacation_accepted')
    assert_equal 'success', n.css_class

    n.kind = 'vacation_rejected'
    assert_equal 'danger', n.css_class
  end
end
