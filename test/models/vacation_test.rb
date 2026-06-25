require 'test_helper'

class VacationTest < ActiveSupport::TestCase
  # ── poprawny urlop ────────────────────────────────────────────────────────
  test 'urlop z poprawnymi danymi jest poprawny' do
    v = build_vacation
    assert v.valid?
  end

  # ── wymagane pola ─────────────────────────────────────────────────────────
  test 'urlop bez start_at jest niepoprawny' do
    v = build_vacation(start_at: nil)
    assert_not v.valid?
    assert v.errors[:start_at].any?
  end

  test 'urlop bez end_at jest niepoprawny' do
    v = build_vacation(end_at: nil)
    assert_not v.valid?
    assert v.errors[:end_at].any?
  end

  # ── walidacja dat ─────────────────────────────────────────────────────────
  test 'urlop z end_at wcześniejszym niż start_at jest niepoprawny' do
    v = build_vacation(start_at: Date.today + 10, end_at: Date.today + 5)
    assert_not v.valid?
    assert v.errors[:base].any?
  end

  test 'urlop z start_at w przeszłości jest niepoprawny przy tworzeniu' do
    v = build_vacation(start_at: Date.today - 1, end_at: Date.today + 5)
    assert_not v.valid?
    assert v.errors[:base].any?
  end

  test 'urlop z start_at dziś jest poprawny' do
    v = build_vacation(start_at: Date.today, end_at: Date.today + 7)
    assert v.valid?
  end

  # ── nakładające się urlopy ────────────────────────────────────────────────
  test 'nakładający się urlop dla tego samego pracownika jest niepoprawny' do
    trainer = people(:trainer)
    Vacation.create!(start_at: Date.today + 1, end_at: Date.today + 10,
                     person: trainer, free: false)
    overlap = build_vacation(start_at: Date.today + 5, end_at: Date.today + 15,
                             person: trainer)
    assert_not overlap.valid?
    assert overlap.errors[:base].any?
  end

  test 'urlop w tym samym czasie dla innego pracownika jest poprawny' do
    Vacation.create!(start_at: Date.today + 1, end_at: Date.today + 10,
                     person: people(:trainer), free: false)
    v = build_vacation(start_at: Date.today + 5, end_at: Date.today + 15,
                       person: people(:manager))
    assert v.valid?
  end

  private

  def build_vacation(overrides = {})
    Vacation.new({
      start_at: Date.today + 5,
      end_at:   Date.today + 12,
      free:     false,
      reason:   'Urlop wypoczynkowy',
      person:   people(:trainer)
    }.merge(overrides))
  end
end
