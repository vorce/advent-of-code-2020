defmodule Aoc2020.Day4Test do
  use ExUnit.Case

  alias Aoc2020.Day4

  # The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).
  # The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.
  # The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.
  @example_input [
    "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
    "byr:1937 iyr:2017 cid:147 hgt:183cm",
    "",
    "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
    "hcl:#cfa07d byr:1929",
    "",
    "hcl:#ae17e1 iyr:2013",
    "eyr:2024",
    "ecl:brn pid:760753108 byr:1931",
    "hgt:179cm",
    "",
    "hcl:#cfa07d eyr:2025 pid:166559648",
    "iyr:2011 ecl:brn hgt:59in"
  ]

  describe "part 1" do
    test "parse example" do
      passports = Day4.parse!(@example_input)

      assert passports == [
               %Day4{
                 byr: "1937",
                 cid: "147",
                 ecl: "gry",
                 eyr: "2020",
                 hcl: "#fffffd",
                 hgt: "183cm",
                 iyr: "2017",
                 pid: "860033327"
               },
               %Day4{
                 byr: "1929",
                 cid: "350",
                 ecl: "amb",
                 eyr: "2023",
                 hcl: "#cfa07d",
                 iyr: "2013",
                 pid: "028048884",
                 hgt: nil
               },
               %Day4{
                 byr: "1931",
                 ecl: "brn",
                 eyr: "2024",
                 hcl: "#ae17e1",
                 hgt: "179cm",
                 iyr: "2013",
                 pid: "760753108",
                 cid: nil
               },
               %Day4{
                 ecl: "brn",
                 eyr: "2025",
                 hcl: "#cfa07d",
                 hgt: "59in",
                 iyr: "2011",
                 pid: "166559648",
                 byr: nil,
                 cid: nil
               }
             ]
    end

    test "valid_passport?/1" do
      valid = %Day4{
        byr: "1937",
        cid: "147",
        ecl: "gry",
        eyr: "2020",
        hcl: "#fffffd",
        hgt: "183cm",
        iyr: "2017",
        pid: "860033327"
      }

      invalid1 = %Day4{
        byr: "1929",
        cid: "350",
        ecl: "amb",
        eyr: "2023",
        hcl: "#cfa07d",
        iyr: "2013",
        pid: "028048884",
        hgt: nil
      }

      missing_cid = %Day4{
        byr: "1931",
        ecl: "brn",
        eyr: "2024",
        hcl: "#ae17e1",
        hgt: "179cm",
        iyr: "2013",
        pid: "760753108",
        cid: nil
      }

      assert Day4.valid_passport?(valid)
      refute Day4.valid_passport?(invalid1)
      assert Day4.valid_passport?(missing_cid)
    end

    test "count_valid example" do
      passports = Day4.parse!(@example_input)
      assert Enum.count(passports, &Day4.valid_passport?/1) == 2
    end

    test "count_valid input file" do
      passports =
        "test/data/day4_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day4.parse!()

      assert length(passports) == 259
      assert Enum.count(passports, &Day4.valid_passport?/1) == 196
    end
  end

  describe "part 2" do
  end
end
