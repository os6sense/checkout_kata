require 'money'

# Set currency default to GBP
Money.default_currency = Money::Currency.new('GBP')

# Don't use i18n since we don't have locales configured
Money.use_i18n = false

# Set rounding to round down rather than the default (half_even)
Money.rounding_mode = BigDecimal::ROUND_DOWN
