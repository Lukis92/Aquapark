require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # ── fixtures są poprawne ──────────────────────────────────────────────────
  test 'manager fixture jest poprawny' do
    assert people(:manager).valid?
  end

  test 'trainer fixture jest poprawny' do
    assert people(:trainer).valid?
  end

  test 'client fixture jest poprawny' do
    assert people(:client).valid?
  end

  # ── wymagane pola ────────────────────────────────────────────────────────
  test 'manager bez first_name jest niepoprawny' do
    p = build_manager(first_name: '')
    assert_not p.valid?
    assert p.errors[:first_name].any?
  end

  test 'manager bez last_name jest niepoprawny' do
    p = build_manager(last_name: '')
    assert_not p.valid?
    assert p.errors[:last_name].any?
  end

  # ── email ────────────────────────────────────────────────────────────────
  test 'manager bez email jest niepoprawny' do
    p = build_manager(email: nil)
    assert_not p.valid?
    assert p.errors[:email].any?
  end

  test 'manager z błędnym formatem email jest niepoprawny' do
    p = build_manager(email: 'nie-email')
    assert_not p.valid?
    assert p.errors[:email].any?
  end

  test 'email jest zapisywany małymi literami' do
    p = build_manager(email: 'TEST@EXAMPLE.COM')
    p.valid?
    assert_equal 'test@example.com', p.email
  end

  test 'manager z duplikatem email jest niepoprawny' do
    duplicate = build_manager(email: people(:manager).email)
    assert_not duplicate.valid?
    assert duplicate.errors[:email].any?
  end

  # ── PESEL (wymagany dla pracowników) ─────────────────────────────────────
  test 'manager bez PESEL jest niepoprawny' do
    p = build_manager(pesel: nil)
    assert_not p.valid?
    assert p.errors[:pesel].any?
  end

  test 'manager z PESEL o złej długości jest niepoprawny' do
    p = build_manager(pesel: '123456')
    assert_not p.valid?
    assert p.errors[:pesel].any?
  end

  test 'manager z PESEL o błędnej sumie kontrolnej jest niepoprawny' do
    p = build_manager(pesel: '91021211230')  # ostatnia cyfra powinna być 6
    assert_not p.valid?
    assert p.errors[:pesel].any?
  end

  test 'manager z duplikatem PESEL jest niepoprawny' do
    duplicate = build_manager(pesel: people(:manager).pesel, email: 'dup@example.com')
    assert_not duplicate.valid?
    assert duplicate.errors[:pesel].any?
  end

  # ── Klient nie wymaga PESEL ──────────────────────────────────────────────
  test 'klient bez PESEL jest poprawny' do
    c = Client.new(first_name: 'Anna', last_name: 'Nowak',
                   date_of_birth: '1990-01-01',
                   email: 'anna.nowak@example.com', password: 'password')
    assert c.valid?
  end

  # ── data urodzenia z PESEL ───────────────────────────────────────────────
  test 'data urodzenia jest wyciągana z PESEL dla pracownika' do
    m = build_manager(pesel: '91021211236')
    m.valid?
    assert_equal Date.new(1991, 2, 12), m.date_of_birth
  end

  test 'PESEL z kodem miesiąca 21+ koduje rok 2000+' do
    m = build_manager(pesel: '02211000017', email: 'y2k@example.com')
    m.valid?
    assert_equal Date.new(2002, 1, 10), m.date_of_birth
  end

  # ── metody ───────────────────────────────────────────────────────────────
  test 'full_name zwraca imię i nazwisko' do
    p = people(:manager)
    assert_equal 'Adam Kierownik', p.full_name
  end

  test 'translate_type zwraca polskie nazwy typów' do
    assert_equal 'Kierownik',    people(:manager).translate_type
    assert_equal 'Trener',       people(:trainer).translate_type
    assert_equal 'Klient',       people(:client).translate_type
  end

  private

  def build_manager(overrides = {})
    Manager.new({
      pesel:      '99030100011',
      first_name: 'Test',
      last_name:  'Manager',
      email:      "test_#{SecureRandom.hex(4)}@example.com",
      password:   'password',
      salary:     5000.00,
      hiredate:   '2020-01-01'
    }.merge(overrides))
  end
end
