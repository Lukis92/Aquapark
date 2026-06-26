require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase
  # ── fixtures ─────────────────────────────────────────────────────────────
  test 'fixture bilet jest poprawny' do
    assert entry_types(:bilet_jednorazowy).valid?
  end

  test 'fixture karnet jest poprawny' do
    assert entry_types(:karnet_miesięczny).valid?
  end

  # ── kind ─────────────────────────────────────────────────────────────────
  test 'entry type bez kind jest niepoprawny' do
    et = build_entry_type(kind: nil)
    assert_not et.valid?
    assert et.errors[:kind].any?
  end

  # ── kind_details ─────────────────────────────────────────────────────────
  test 'entry type bez kind_details jest niepoprawny' do
    et = build_entry_type(kind_details: nil)
    assert_not et.valid?
    assert et.errors[:kind_details].any?
  end

  test 'entry type z kind_details krótszym niż 3 znaki jest niepoprawny' do
    et = build_entry_type(kind_details: 'AB')
    assert_not et.valid?
    assert et.errors[:kind_details].any?
  end

  # ── price ─────────────────────────────────────────────────────────────────
  test 'entry type bez price jest niepoprawny' do
    et = build_entry_type(price: nil)
    assert_not et.valid?
    assert et.errors[:price].any?
  end

  test 'entry type z price równym 0 jest niepoprawny' do
    et = build_entry_type(price: 0)
    assert_not et.valid?
    assert et.errors[:price].any?
  end

  test 'entry type z ujemnym price jest niepoprawny' do
    et = build_entry_type(price: -10)
    assert_not et.valid?
    assert et.errors[:price].any?
  end

  test 'entry type z price >= 999 jest niepoprawny' do
    et = build_entry_type(price: 999)
    assert_not et.valid?
    assert et.errors[:price].any?
  end

  test 'entry type z prawidłowymi danymi jest poprawny' do
    et = build_entry_type
    assert et.valid?
  end

  # ── scopes ───────────────────────────────────────────────────────────────
  test 'scope tickets zwraca tylko bilety' do
    EntryType.tickets.each { |et| assert_equal 'Bilet', et.kind }
  end

  test 'scope passes zwraca tylko karnety' do
    EntryType.passes.each { |et| assert_equal 'Karnet', et.kind }
  end

  private

  def build_entry_type(overrides = {})
    EntryType.new({
      kind:         'Bilet',
      kind_details: 'Bilet grupowy',
      description:  'Wejście grupowe',
      price:        30.00
    }.merge(overrides))
  end
end
