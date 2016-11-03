#!/usr/bin/env elixir

# PROBLEM:
# Write a routine to calculate the angle between the hands of a clock.
# Also create some test data.
# Use any language you like.
# The C++ function signature follows.
#   // hours: 0 to 23
#   // minutes: 0 to 59
#   // output: 0 to 180 degrees, -1 error on invalid input
#   uint32_t ClockAngle(uint32_t hours, uint32_t minutes)

# MY NOTES:
# The simple solution is:
#   return (30 * hours) - (6 * minutes);
# The less simple solution is:
#   return (30 * hours + minutes / 2) - (6 * minutes);

# OTHER THOUGHTS:
# The problem itself is so simple someone bad at trigonometry should be able to solve it.
# Trigonometry problems should generally be solved in radians.
# Trigonometric functions are periodic, so there are an infinite number of solutions if measuring position.
# When measuring movement in degrees, the number of revolutions has meaning.
# -1 moonlights as an error code in C++, but atoms are a better choice in Elixir.

# A single file solution written in Elixir follows.
# Run with the following flags for the above spec.
#   ./clock_angle.exs -a -b -+ -n -h HOURS -m MINUTES
# To see a list of the command line arguments, run the following.
# Note that formatting flags affect the test data.
#   chmod +x clock_angle.exs
#   ./clock_angle.exs --help
# Examples:
#   ./clock_angle.exs -h 3 -m 30
#   ./clock_angle.exs -h 8 -m 10 -r --no-pi -p 4
#   ./clock_angle.exs -h 8 -m 10 -r --no-pi -p 4 -n
#   ./clock_angle.exs -h 2 -m 37 -d -p 0
#   ./clock_angle.exs -h 24 -m 44
#   ./clock_angle.exs -h 24 -m 44 -a
#   ./clock_angle.exs -h 24 -m 44 -n
#   ./clock_angle.exs -h 24 -m 44 -+
#   ./clock_angle.exs -h 24 -m 44 -n -+
#   ./clock_angle.exs -h 24 -m 44 -b
#   ./clock_angle.exs -t -p 2
#   ./clock_angle.exs -t -d -p 0 -a -n -+ -b

defmodule ClockAngle do
  @hours_in_day 24
  @hours_in_circle 12
  @minutes_in_circle 60  
  @radians_in_circle 2*:math.pi

  def integerToRadians(pValue, pMax) do
    pValue
    |> Kernel./(pMax)
    |> Kernel.*(@radians_in_circle)
  end

  def hourToRadians(pHour) do
    integerToRadians(pHour, @hours_in_circle)
  end

  def adjustHourInRadians(pMinute) do
    pMinute
    |> Kernel./(@minutes_in_circle)
    |> Kernel.*(@radians_in_circle)
    |> Kernel./(@hours_in_circle)
  end

  def minuteToRadians(pMinute) do
    integerToRadians(pMinute, @minutes_in_circle)
  end

  def normalize(pValue) when
    pValue < 0 or @radians_in_circle <= pValue
  do
    pValue
    |> Kernel./(@radians_in_circle) # number of revolutions
    |> Float.floor # number of complete revolutions
    |> Kernel.*(-@radians_in_circle) # excess complete revolutions
    |> Kernel.+(pValue) # partial revolution remains
  end

  def normalize(pValue) do
    pValue
  end

  def normalize_difference(pValue) when
    pValue < 0 or @radians_in_circle <= pValue
  do
    pValue
    |> normalize
    |> normalize_difference
  end

  def normalize_difference(pValue) when
    @radians_in_circle / 2 <= pValue
  do
    @radians_in_circle - pValue
  end

  def normalize_difference(pValue), do: pValue

  def radians(pHour, pMinute, pAdjustHour \\ false, pNormalize \\ false, pPositiveResult \\ false, pCheckBounds \\ false)

  def radians(pHour, pMinute, _pAdjustHour, _pNormalize, _pPositiveResult, true) when
    pHour < 0 or @hours_in_day <= pHour or
    pMinute < 0 or @minutes_in_circle <= pMinute
  do
    :error
  end

  # do not adjust hour hand
  def radians(pHour, pMinute, false, false, false, _pCheckBounds) do
    minuteToRadians(pMinute) - hourToRadians(pHour)
  end

  # adjust hour hand
  def radians(pHour, pMinute, true, false, false, _pCheckBounds) do
    minuteToRadians(pMinute) - hourToRadians(pHour) - adjustHourInRadians(pMinute)
  end

  # normalize result
  def radians(pHour, pMinute, pAdjustHour, true, false, pCheckBounds) do
    radians(pHour, pMinute, pAdjustHour, false, false, pCheckBounds)
    |> normalize
  end

  # positive result
  def radians(pHour, pMinute, pAdjustHour, false, true, pCheckBounds) do
    radians(pHour, pMinute, pAdjustHour, false, false, pCheckBounds)
    |> Kernel.abs
  end

  # normalize positive result
  def radians(pHour, pMinute, pAdjustHour, true, true, pCheckBounds) do
    radians(pHour, pMinute, pAdjustHour, false, false, pCheckBounds)
    |> normalize_difference
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

  def angle(:error, _pOptions), do: "ERROR"

  def angle(pAngle, pOptions) do
    # [radians: false, degrees: false] -> [radians: true]
    # [radians: true, degrees: true] -> [radians: true]
    # [radians: true, degrees: false] -> [radians: true]
    # [radians: false, degrees: true] -> [radians: false]
    radians = pOptions[:radians] or not pOptions[:degrees]
    if radians do
      radians(pAngle, pOptions)
    else
      degrees(radiansToDegrees(pAngle), pOptions)
    end
  end

  def radians(pRadians, pOptions) do
    precision = pOptions[:precision]
    pi = pOptions[:pi]
    if pi do
      "#{pRadians |> Kernel./(:math.pi) |> round(precision)} PI radians"
    else
      "#{pRadians |> round(precision)} radians"
    end
  end

  def degrees(pDegrees, pOptions) do
    precision = pOptions[:precision]
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
  @hours_in_day 24
  @minutes_in_circle 60
  @radians_in_circle 2*:math.pi

  def conditionalNormalize(pValue, true, true), do: ClockAngle.normalize_difference(pValue)
  def conditionalNormalize(pValue, true, false), do: ClockAngle.normalize(pValue)
  def conditionalNormalize(pValue, false, true), do: abs(pValue)
  def conditionalNormalize(pValue, false, false), do: pValue

  def round(pValue, _pPrecision) when is_atom(pValue), do: pValue
  def round(pValue, pPrecision), do: pValue |> Float.round(pPrecision)

  def case(pHour, pMinute, pExpected, pOptions) do
    adjust = pOptions[:adjust]
    normalize = pOptions[:normalize]
    positive = pOptions[:positive]
    bounds = pOptions[:bounds]
    precision = pOptions[:precision]

    actual = ClockAngle.radians(pHour, pMinute, adjust, normalize, positive, bounds)
    actual_rounded = actual |> round(precision)

    expected = pExpected
    |> conditionalAdjustMinutes(pMinute, adjust)
    |> conditionalNormalize(normalize, positive)
    |> conditionalBounds(pHour, pMinute, bounds)
    expected_rounded = expected |> round(precision)

    {result, operator} = if actual_rounded == expected_rounded do
      {"PASS", "=="}
    else
      {"FAIL", "!="}
    end
    IO.puts("#{result} #{Format.time(pHour, pMinute)} : Actual #{Format.angle(actual, pOptions)} #{operator} Expected #{Format.angle(expected, pOptions)}")
  end

  def minutesForward(pMinute) do
    pMinute / @minutes_in_circle * @radians_in_circle
  end

  def conditionalAdjustMinutes(pInitialValue, _pMinute, false), do: pInitialValue

  def conditionalAdjustMinutes(pInitialValue, pMinute, true) do
    pInitialValue - ClockAngle.adjustHourInRadians(pMinute)
  end

  def conditionalBounds(_pValue, pHour, pMinute, true) when
    pHour < 0 or @hours_in_day <= pHour or
    pMinute < 0 or @minutes_in_circle <= pMinute
  do
    :error
  end

  def conditionalBounds(pValue, _pHour, _pMinute, _bounds), do: pValue

  def all(pOptions) do
    case( 3,  0, minutesForward(-15), pOptions)
    case( 3,  5, minutesForward(-10), pOptions)
    case( 3, 10, minutesForward(-5), pOptions)
    case( 3, 15, minutesForward(0), pOptions)
    case( 3, 20, minutesForward(5), pOptions)
    case( 3, 25, minutesForward(10), pOptions)
    case( 3, 30, minutesForward(15), pOptions)
    case( 3, 35, minutesForward(20), pOptions)
    case( 3, 40, minutesForward(25), pOptions)
    case( 3, 45, minutesForward(30), pOptions)
    case( 3, 50, minutesForward(35), pOptions)
    case( 3, 55, minutesForward(40), pOptions)
    case( 3, 60, minutesForward(45), pOptions)
    case( 0, 37, minutesForward(37), pOptions)
    case( 1, 37, minutesForward(32), pOptions)
    case( 2, 37, minutesForward(27), pOptions)
    case( 3, 37, minutesForward(22), pOptions)
    case( 4, 37, minutesForward(17), pOptions)
    case( 5, 37, minutesForward(12), pOptions)
    case( 6, 37, minutesForward(7), pOptions)
    case( 7, 37, minutesForward(2), pOptions)
    case( 8, 37, minutesForward(-3), pOptions)
    case( 9, 37, minutesForward(-8), pOptions)
    case(10, 37, minutesForward(-13), pOptions)
    case(11, 37, minutesForward(-18), pOptions)
    case(12, 37, minutesForward(-23), pOptions)
    case(13, 37, minutesForward(-28), pOptions)
    case(14, 37, minutesForward(-33), pOptions)
    case(15, 37, minutesForward(-38), pOptions)
    case(16, 37, minutesForward(-43), pOptions)
    case(17, 37, minutesForward(-48), pOptions)
    case(18, 37, minutesForward(-53), pOptions)
    case(19, 37, minutesForward(-58), pOptions)
    case(20, 37, minutesForward(-63), pOptions)
    case(21, 37, minutesForward(-68), pOptions)
    case(22, 37, minutesForward(-73), pOptions)
    case(23, 37, minutesForward(-78), pOptions)
    case(24, 11, minutesForward(-109), pOptions)
    case(-2, 99, minutesForward(109), pOptions)
    case(-1, -1, minutesForward(4), pOptions)
    case(-1,  0, minutesForward(5), pOptions)
    case( 0, -1, minutesForward(-1), pOptions)
    case( 0,  0, minutesForward(0), pOptions)
    case(23, 59, minutesForward(-56), pOptions)
    case(23, 60, minutesForward(-55), pOptions)
    case(24, 59, minutesForward(-61), pOptions)
    case(24, 60, minutesForward(-60), pOptions)
  end
end

defmodule Script do
  def main(args) do
    defaults = [
      hour: 0,
      minute: 0,
      precision: 3,
      adjust: false,
      normalize: false,
      positive: false,
      bounds: false,
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
      adjust: :boolean,
      normalize: :boolean,
      positive: :boolean,
      bounds: :boolean,
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
      a: :adjust,
      n: :normalize,
      "+": :positive,
      b: :bounds,
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
    IO.puts("    --adjust           : adjust hour hand as minute hand moves")
    IO.puts("    -a                 : adjust hour hand as minute hand moves")
    IO.puts("    --normalize        : clamp result to [0, 2.0 PI) radians or [0, 360) degrees")
    IO.puts("    -n                 : clamp result to [0, 2.0 PI) radians or [0, 360) degrees")
    IO.puts("    --positive         : result is positive difference between clock hands")
    IO.puts("    -+                 : result is positive difference between clock hands")
    IO.puts("                       : use --normalize and --positive clamp result to [0, PI) radians or [0, 180) degrees")
    IO.puts("    --bounds           : error unless 0 <= hours < 24 and 0 <= minutes < 60")
    IO.puts("    -b                 : error unless 0 <= hours < 24 and 0 <= minutes < 60")
    IO.puts("    --test             : run test cases")
    IO.puts("    -t                 : run test cases")
    IO.puts("    --help             : display this usage summary")
    IO.puts("    -?                 : display this usage summary")
    IO.puts("Examples:")
    IO.puts("  clock_angle -h 3 -m 30")
    IO.puts("  clock_angle -h 8 -m 10 -r --no-pi -p 4")
    IO.puts("  clock_angle -h 8 -m 10 -r --no-pi -p 4 -n")
    IO.puts("  clock_angle -h 2 -m 37 -d -p 0")
    IO.puts("  clock_angle -h 24 -m 44")
    IO.puts("  clock_angle -h 24 -m 44 -a")
    IO.puts("  clock_angle -h 24 -m 44 -n")
    IO.puts("  clock_angle -h 24 -m 44 -+")
    IO.puts("  clock_angle -h 24 -m 44 -n -+")
    IO.puts("  clock_angle -h 24 -m 44 -b")
    IO.puts("  clock_angle -t -p 2")
    IO.puts("  clock_angle -t -d -p 0 -a -n -+ -b")
  end

  def process(pOptions) do
    hour = pOptions[:hour]
    minute = pOptions[:minute]
    adjust = pOptions[:adjust]
    normalize = pOptions[:normalize]
    positive = pOptions[:positive]
    bounds = pOptions[:bounds]
    angle = ClockAngle.radians(hour, minute, adjust, normalize, positive, bounds)
    output(Format.time(hour, minute), Format.angle(angle, pOptions))
  end

  def output(pTime, pAngle) do
    IO.puts("#{pTime} -> #{pAngle}")
  end
end

Script.main(System.argv)

