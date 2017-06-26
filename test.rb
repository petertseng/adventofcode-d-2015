require_relative '../adventofcode-common/test'

test_and_exit { |daypad|
  f = "#{__dir__}/aoc#{daypad}"
  File.exist?(f) && f
}
