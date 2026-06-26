require 'test_helper'

class WorkScheduleTest < ActiveSupport::TestCase
  # ── fixture ───────────────────────────────────────────────────────────────
  test 'fixture trainer_monday jest poprawny' do
    assert work_schedules(:trainer_monday).valid?
  end

  # ── wymagane pola ─────────────────────────────────────────────────────────
  test 'grafik bez day_of_week jest niepoprawny' do
    ws = build_work_schedule(day_of_week: nil)
    assert_not ws.valid?
    assert ws.errors[:day_of_week].any?
  end

  test 'grafik bez start_time jest niepoprawny' do
    ws = build_work_schedule(start_time: nil)
    assert_not ws.valid?
    assert ws.errors[:start_time].any?
  end

  test 'grafik bez end_time jest niepoprawny' do
    ws = build_work_schedule(end_time: nil)
    assert_not ws.valid?
    assert ws.errors[:end_time].any?
  end

  # ── walidacja godzin ──────────────────────────────────────────────────────
  test 'grafik z end_time wcześniejszym niż start_time jest niepoprawny' do
    ws = build_work_schedule(start_time: '14:00:00', end_time: '08:00:00')
    assert_not ws.valid?
    assert ws.errors[:base].any?
  end

  test 'grafik z end_time równym start_time jest niepoprawny' do
    ws = build_work_schedule(start_time: '08:00:00', end_time: '08:00:00')
    assert_not ws.valid?
    assert ws.errors[:base].any?
  end

  test 'grafik krótszy niż 1 godzina jest niepoprawny' do
    ws = build_work_schedule(start_time: '08:00:00', end_time: '08:30:00')
    assert_not ws.valid?
    assert ws.errors[:base].any?
  end

  # ── unikalność dnia dla pracownika ────────────────────────────────────────
  test 'drugi grafik w tym samym dniu dla tego samego pracownika jest niepoprawny' do
    trainer = people(:trainer)
    duplicate = WorkSchedule.new(
      day_of_week: work_schedules(:trainer_monday).day_of_week,
      start_time:  '10:00:00',
      end_time:    '18:00:00',
      person:      trainer
    )
    assert_not duplicate.valid?
    assert duplicate.errors[:day_of_week].any?
  end

  test 'ten sam dzień dla innego pracownika jest poprawny' do
    manager = people(:manager)
    ws = WorkSchedule.new(
      day_of_week: 'Poniedziałek',
      start_time:  '08:00:00',
      end_time:    '16:00:00',
      person:      manager
    )
    assert ws.valid?
  end

  private

  def build_work_schedule(overrides = {})
    WorkSchedule.new({
      day_of_week: 'Wtorek',
      start_time:  '09:00:00',
      end_time:    '17:00:00',
      person:      people(:trainer)
    }.merge(overrides))
  end
end
