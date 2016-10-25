#!/usr/bin/env elixir

# PROBLEM:
# Write a routine to calculate the angle between the hands of a clock.
# Also create some test data.
# Use any language you like.
# The C++ function signature follows.
#   uint32_t ClockAngle(uint32_t hours, uint32_t minutes)

# MY NOTES:
# A solution in degrees seems to be implied by unt32_t.
# The simple solution is:
#   return (30 * hours) - (6 * minutes);
# The direction of the measurement is not defined.
# A range of acceptable return values, like [0, 360) is not defined.

# OTHER THOUGHTS:
# The problem itself is so simple someone bad at trigonometry should be able to solve it.
# Trigonometry problems should generally be solved in radians.
# Trigonometric functions are periodic, so there are an infinite number of solutions if measuring position.
# When measuring movement in degrees, the number of revolutions has meaning.

# A single file solution written in Elixir follows.
# To see a list of the command line arguments, run the following.
# Note that formatting flags affect the test data.
#   chmod +x clock_angle.exs
#   ./clock_angle.exs --help
# Examples:
#   ./clock_angle.exs -h 3 -m 30
#   ./clock_angle.exs -h 8 -m 10 -r --no-pi -p 4
#   ./clock_angle.exs -h 8 -m 10 -r --no-pi -p 4 -n
#   ./clock_angle.exs -h 2 -m 37 -d -p 0
#   ./clock_angle.exs -t -p 2
#   ./clock_angle.exs -t -d -n -p 0

defmodule ClockAngle do
  @hour_max 12
  @minute_max 60  
  @radians_in_circle 2*:math.pi

  def integerToRadians(pValue, pMax) do
    pValue
    |> Kernel./(pMax)
    |> Kernel.*(@radians_in_circle)
  end

  def hourToRadians(pHour) do
    integerToRadians(pHour, @hour_max)
  end

  def minuteToRadians(pMinute) do
    integerToRadians(pMinute, @minute_max)
  end

  def normalize(pValue) when pValue < 0 or @radians_in_circle <= pValue do
    pValue
    |> Kernel./(@radians_in_circle)
    |> Float.floor
    |> Kernel.*(-@radians_in_circle)
    |> Kernel.+(pValue)
  end

  def normalize(pValue) do
    pValue
  end

  def radians(pHour, pMinute, pNormalize \\ false)
  def radians(pHour, pMinute, false) do
    minuteToRadians(pMinute) - hourToRadians(pHour)
  end

  def radians(pHour, pMinute, true) do
    radians(pHour, pMinute, false)
    |> normalize
  end
end

defmodule Format do
  @degrees_in_circle 360
  @radians_in_circle 2*:math.pi

  def radiansToDegrees(pRadians) do
    pRadians
    |> Kernel.*(@degrees_in_circle)
    |> Kernel./(@radians_in_circle)
  end

  def angle(pAngle, opt) do
    # [radians: false, degrees: false] -> [radians: true]
    # [radians: true, degrees: true] -> [radians: true]
    # [radians: true, degrees: false] -> [radians: true]
    # [radians: false, degrees: true] -> [radians: false]
    radians = opt[:radians] or not opt[:degrees]
    if radians do
      radians(pAngle, opt)
    else
      degrees(radiansToDegrees(pAngle), opt)
    end
  end

  def radians(pRadians, opt) do
    precision = opt[:precision]
    pi = opt[:pi]
    if pi do
      "#{pRadians |> Kernel./(:math.pi) |> round(precision)} PI radians"
    else
      "#{pRadians |> round(precision)} radians"
    end
  end

  def degrees(pDegrees, opt) do
    precision = opt[:precision]
    "#{pDegrees |> round(precision)} degrees"
  end

  def twoDigitNumber(pValue) do
    pValue
    |> Integer.to_string
    |> String.rjust(2, ?0)
  end

  def time(pHour, pMinute) do
    "#{pHour |> twoDigitNumber}:#{pMinute |> twoDigitNumber}"
  end

  def round(pValue, 0), do: pValue |> Float.round(0) |> trunc
  def round(pValue, pPrecision), do: pValue |> Float.round(pPrecision)
end

defmodule Test do
  @minutes_in_circle 60
  @radians_in_circle 2*:math.pi

  def conditionalNormalize(pValue, true), do: ClockAngle.normalize(pValue)
  def conditionalNormalize(pValue, false), do: pValue

  def case(pHour, pMinute, pExpected, opt) do
    precision = opt[:precision]
    normalize = opt[:normalize]

    actual = ClockAngle.radians(pHour, pMinute, normalize)
    actual_rounded = actual |> Float.round(precision)

    expected = pExpected |> conditionalNormalize(normalize)
    expected_rounded = expected |> Float.round(precision)

    {result, operator} = if actual_rounded == expected_rounded do
      {"PASS", "=="}
    else
      {"FAIL", "!="}
    end
    IO.puts("#{result} #{Format.time(pHour, pMinute)} : Actual #{Format.angle(actual, opt)} #{operator} Expected #{Format.angle(expected, opt)}")
  end

  def minutesForward(pMinutes) do
    pMinutes / @minutes_in_circle * @radians_in_circle
  end

  def all(opt) do
    case( 3,  0, minutesForward(-15), opt)
    case( 3,  5, minutesForward(-10), opt)
    case( 3, 10, minutesForward(-5), opt)
    case( 3, 15, minutesForward(0), opt)
    case( 3, 20, minutesForward(5), opt)
    case( 3, 25, minutesForward(10), opt)
    case( 3, 30, minutesForward(15), opt)
    case( 3, 35, minutesForward(20), opt)
    case( 3, 40, minutesForward(25), opt)
    case( 3, 45, minutesForward(30), opt)
    case( 3, 50, minutesForward(35), opt)
    case( 3, 55, minutesForward(40), opt)
    case( 3, 60, minutesForward(45), opt)
    case( 0, 37, minutesForward(37), opt)
    case( 1, 37, minutesForward(32), opt)
    case( 2, 37, minutesForward(27), opt)
    case( 3, 37, minutesForward(22), opt)
    case( 4, 37, minutesForward(17), opt)
    case( 5, 37, minutesForward(12), opt)
    case( 6, 37, minutesForward(7), opt)
    case( 7, 37, minutesForward(2), opt)
    case( 8, 37, minutesForward(-3), opt)
    case( 9, 37, minutesForward(-8), opt)
    case(10, 37, minutesForward(-13), opt)
    case(11, 37, minutesForward(-18), opt)
    case(12, 37, minutesForward(-23), opt)
    case(24, 11, minutesForward(-109), opt)
    case(-2, 99, minutesForward(109), opt)
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      hour: 0,
      minute: 0,
      precision: 3,
      normalize: false,
      radians: false,
      degrees: false,
      pi: true,
      test: false,
      help: false,
    ]
    switches = [
      hour: :integer,
      minute: :integer,
      precision: :integer,
      normalize: :boolean,
      radians: :boolean,
      degrees: :boolean,
      pi: :boolean,
      test: :boolean,
      help: :boolean,
    ]
    aliases = [
      h: :hour,
      m: :minute,
      p: :precision,
      n: :normalize,
      r: :radians,
      d: :degrees,
      t: :test,
      P: :pi,
      "?": :help,
    ]
    {parsed, remaining, invalid} = OptionParser.parse(args, strict: switches, aliases: aliases)
    options = defaults
    |> Keyword.merge(parsed)
    cond do
      options[:help] or (0 < length remaining) or (0 < length invalid) ->
        usage
      options[:test] ->
        Test.all(options)
      true ->
        process(options)
    end
  end

  def usage() do
    IO.puts("Calculates the angle between hands of a clock.")
    IO.puts("The angle is measured from the hour hand to the minute hand in the clockwise direction.")
    IO.puts("The caluclation assumes the hour and minute hands point directly at the numbers on the clock.")
    IO.puts("Formatting flags affect test data output.")
    IO.puts("Usage:")
    IO.puts("  clock_angle --hour HOUR --minute MINUTE [--precision DIGITS] [--radians [--pi]|--degrees] [--normalize] [--test|--help]")
    IO.puts("    --hour      HOUR   : clock hour, default 0")
    IO.puts("    -h          HOUR   : clock hour, default 0")
    IO.puts("    --minute    MINUTE : clock minute, default 0")
    IO.puts("    -m          MINUTE : clock minute, default 0")
    IO.puts("    --precision DIGITS : number of digits to round result to, default 3")
    IO.puts("    -p          DIGITS : number of digits to round result to, default 3")
    IO.puts("    --radians          : result in radians, default")
    IO.puts("    -r                 : result in radians, default")
    IO.puts("    --degrees          : result in degrees")
    IO.puts("    -d                 : result in degrees")
    IO.puts("    --pi               : display radians as a multiple of PI, default")
    IO.puts("    -P                 : display radians as a multiple of PI, default")
    IO.puts("    --no-pi            : do not display radians as a multiple of PI")
    IO.puts("    --normalize        : clamp result to [0, 2.0 PI) radians or [0, 360) degrees")
    IO.puts("    -n                 : clamp result to [0, 2.0 PI) radians or [0, 360) degrees")
    IO.puts("    --test             : run test cases")
    IO.puts("    -t                 : run test cases")
    IO.puts("    --help             : display this usage summary")
    IO.puts("    -?                 : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  clock_angle -h 3 -m 30")
    IO.puts("  clock_angle -h 8 -m 10 -r --no-pi -p 4")
    IO.puts("  clock_angle -h 8 -m 10 -r --no-pi -p 4 -n")
    IO.puts("  clock_angle -h 2 -m 37 -d -p 0")
    IO.puts("  clock_angle -t -p 2")
    IO.puts("  clock_angle -t -d -n -p 0")
  end

  def process(opt \\ []) do
    hour = opt[:hour]
    minute = opt[:minute]
    normalize = opt[:normalize]
    angle = ClockAngle.radians(hour, minute, normalize)
    output(Format.time(hour, minute), Format.angle(angle, opt))
  end

  def output(pTime, pAngle) do
    IO.puts("#{pTime} -> #{pAngle}")
  end
end

Script.main(System.argv)

