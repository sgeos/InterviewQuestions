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
# -1 moonlights as an error code in C++, but atoms are a better way of expressing errors in Elixir.

# A single file solution written in Elixir follows.
# Note that flags affect the test data computations and output.
# Run with the following flags to match the C++ spec.
#   ./clock_angle.exs -a -b -+ -n -h HOURS -m MINUTES
#
# To see a list of the command line arguments, run the following.
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

  def hourToRadians(%{hour: pHour, minute: pMinute, adjust: true}) do
    pMinute
    |> Kernel./(@minutes_in_circle) # normalize to a value from [0,1)
    |> Kernel.*(@radians_in_circle) # fraction of circumference of circle
    |> Kernel./(@hours_in_circle) # fraction between hour positions
    |> Kernel.+(hourToRadians(%{hour: pHour})) # add base result
  end

  def hourToRadians(%{hour: pHour}) do
    integerToRadians(pHour, @hours_in_circle)
  end

  def minuteToRadians(%{minute: pMinute}) do
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

  def neuterOptions(pOptions) do
    pOptions
    |> Map.merge(%{normalize: false, positive: false})
  end

  def radians(pOptions \\ %{})

  def radians(%{hour: pHour, minute: pMinute, bounds: true}) when
    pHour < 0 or @hours_in_day <= pHour or
    pMinute < 0 or @minutes_in_circle <= pMinute
  do
    :error
  end

  # normalized positive result
  def radians(%{normalize: true, positive: true} = pOptions) do
    radians(pOptions |> neuterOptions)
    |> normalize_difference
  end

  # normalize result
  def radians(%{normalize: true} = pOptions) do
    radians(pOptions |> neuterOptions)
    |> normalize
  end

  # positive result
  def radians(%{positive: true} = pOptions) do
    radians(pOptions |> neuterOptions)
    |> Kernel.abs
  end

  # base result
  def radians(%{hour: _pHour, minute: _pMinute} = pOptions) do
    minuteToRadians(pOptions) - hourToRadians(pOptions)
  end

  # catch all
  def radians(_), do: :error
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
  @hour_skip 1
  @minutes_in_circle 60
  @minute_skip 5
  @radians_in_circle 2*:math.pi

  def conditionalNormalize(pValue, true, true), do: ClockAngle.normalize_difference(pValue)
  def conditionalNormalize(pValue, true, false), do: ClockAngle.normalize(pValue)
  def conditionalNormalize(pValue, false, true), do: abs(pValue)
  def conditionalNormalize(pValue, false, false), do: pValue

  def round(pValue, _pPrecision) when is_atom(pValue), do: pValue
  def round(pValue, pPrecision), do: pValue |> Float.round(pPrecision)

  def case(pHour, pMinute, pExpected, pOptions) do
    options = pOptions |> Map.merge(%{hour: pHour, minute: pMinute})
    precision = options[:precision]
    adjust = options[:adjust]
    normalize = options[:normalize]
    positive = options[:positive]
    bounds = options[:bounds]

    actual = ClockAngle.radians(options)
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
    %{minute: -pMinute, hour: 0, adjust: true} # subtract minute adjustment
    |> ClockAngle.hourToRadians # get adjustment
    |> Kernel.+(pInitialValue) # apply adjustment
  end

  def conditionalBounds(_pValue, pHour, pMinute, true) when
    pHour < 0 or @hours_in_day <= pHour or
    pMinute < 0 or @minutes_in_circle <= pMinute
  do
    :error
  end

  def conditionalBounds(pValue, _pHour, _pMinute, _bounds), do: pValue

  def all(pOptions) do
    # the testing ranges and skip values could be parameterized,
    # but this project just needs to be done

    # loop through hours
    -@hour_skip..@hours_in_day
    |> Enum.take_every(@hour_skip)
    |> Enum.each( &(case(&1, 37, minutesForward(37 - &1*5), pOptions)) )
    # loop through minutes
    -@minute_skip..@minutes_in_circle
    |> Enum.take_every(@minute_skip)
    |> Enum.each( &(case(3, &1, minutesForward(&1 - 15), pOptions)) )
    # bounds test
    case(-1, -1, minutesForward(4), pOptions)
    case(-1,  0, minutesForward(5), pOptions)
    case( 0, -1, minutesForward(-1), pOptions)
    case( 0,  0, minutesForward(0), pOptions)
    case(23, 59, minutesForward(-56), pOptions)
    case(23, 60, minutesForward(-55), pOptions)
    case(24, 59, minutesForward(-61), pOptions)
    case(24, 60, minutesForward(-60), pOptions)
    # out of bounds
    case(-2, 99, minutesForward(109), pOptions)
    case(33, -77, minutesForward(-242), pOptions)
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
    |> Enum.into(%{})
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
    IO.puts("  clock_angle --hour HOUR --minute MINUTE [--precision DIGITS] [--radians [--pi|--no-pi]|--degrees] [--adjust] [--normalize] [--positive] [--bounds] [--test|--help]")
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
    radians = ClockAngle.radians(pOptions)
    output(Format.time(hour, minute), Format.angle(radians, pOptions))
  end

  def output(pTime, pAngle) do
    IO.puts("#{pTime} -> #{pAngle}")
  end
end

Script.main(System.argv)

