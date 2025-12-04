#include <print>
#include <fstream>
#include <filesystem>
#include <assert.h>
#include <charconv>
#include <ranges>
#include <cmath>

int CountDigits(long num)
{
	return std::to_string(num).size();
}

template <typename T> static void CheckIds(T checker)
{
	std::fstream file("in");
	auto size = std::filesystem::file_size("in");
	std::string data(size, 0);
	size_t res = 0;

	file.read(data.data(), size);

	data.erase(std::remove(data.begin(), data.end(), '\n'), data.end());

	for (const auto &i : data | std::views::split(',')) {
		auto range = std::string_view(i);
		auto sep = range.find('-');
		long start, end;

		assert(std::from_chars(range.data(), range.data() + sep, start)
			       .ec == std::errc{});
		assert(std::from_chars(range.data() + sep + 1,
				       range.data() + range.size(), end)
			       .ec == std::errc{});

		for (auto i = start; i <= end; ++i) {
			if (checker(i)) {
				res += i;
			}
		}
	}

	std::print("{}\n", res);
}

static void part1(void)
{
	auto IsInvalid = [](long val) {
		size_t num = CountDigits(val);
		size_t half = num / 2;
		size_t pow = std::pow(10, half);

		if (num & 1)
			return false;

		return val / pow == val % pow;
	};

	CheckIds(IsInvalid);
}

static void part2(void)
{
	auto CheckCount = [](size_t val, size_t pow) {
		size_t prev = val % pow;

		if (val <= pow)
			return false;

		val /= pow;
		while (val) {
			if (prev != val % pow) {
				return false;
			}

			val /= pow;
		}

		return true;
	};

	auto IsInvalid = [CheckCount](long val) {
		size_t num = CountDigits(val);
		size_t pow = 10;

		for (int i = 1; i <= num / 2; ++i, pow *= 10) {
			if (num % i == 0 && CheckCount(val, pow))
				return true;
		}

		return false;
	};

	CheckIds(IsInvalid);
}

int main(void)
{
	part2();
}
