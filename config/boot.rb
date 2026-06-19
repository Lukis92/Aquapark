ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'bigdecimal'

unless BigDecimal.respond_to?(:new)
  def BigDecimal.new(*args)
    BigDecimal(*args)
  end
end

module Kernel
  alias_method :gem_without_rails42_pg_check, :gem

  def gem(name, *requirements)
    if name == 'pg' && requirements == ['~> 0.15'] && Gem.loaded_specs['pg']
      true
    else
      gem_without_rails42_pg_check(name, *requirements)
    end
  end
end

require 'pg'

PGconn = PG::Connection unless defined?(PGconn)
PGresult = PG::Result unless defined?(PGresult)
PGError = PG::Error unless defined?(PGError)
