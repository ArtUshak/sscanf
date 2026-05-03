#define SSCANF_NO_NICE_FEATURES

#include <a_samp>
#include <sscanf2>

ASSERT_EQ(actual, expected, const message[])
{
	if (actual != expected)
	{
		printf("SSCANF test failed: %s, expected: %d, got: %d", message, expected, actual);
	}
}

main()
{
	SSCANF_Option(SSCANF_QUIET, 1);

	ASSERT_EQ(SSCANF_GetErrorCategory(1004), SSCANF_ERROR_MISSING, "SSCANF_ERROR_MISSING");
	ASSERT_EQ(SSCANF_GetErrorCategory(1009), SSCANF_ERROR_EXCESS, "SSCANF_ERROR_EXCESS");
	ASSERT_EQ(SSCANF_GetErrorCategory(1001), SSCANF_ERROR_COLOUR, "SSCANF_ERROR_COLOUR");
	ASSERT_EQ(SSCANF_GetErrorCategory(2), SSCANF_ERROR_OVERFLOW, "SSCANF_ERROR_OVERFLOW");
	ASSERT_EQ(SSCANF_GetErrorCategory(1003), SSCANF_ERROR_NOT_FOUND, "SSCANF_ERROR_NOT_FOUND");
	ASSERT_EQ(SSCANF_GetErrorCategory(1010), SSCANF_ERROR_NO_ALTS, "SSCANF_ERROR_NO_ALTS");

	new str[8];
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "s[8]", str), 0, "1");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>s[8]", str), 2, "2");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>s[8]", str), 3 | (2 << 16), "3");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<ERROR_CODE_IN_RET=1>s[8]", str), 0, "4");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>s[8]", str), 3, "5");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>s[8]", str), 0, "6");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>s[8]", str), 0, "7a");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>?s[8]", str), 2, "7b");
	ASSERT_EQ(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>s[8]", str), 4 | (7 << 16), "8");

	new int;
	ASSERT_EQ(sscanf("not-a-number", "i", int), 1, "9");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>i", int), 2, "10");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>i", int), 3 | (1011 << 16), "11");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CODE_IN_RET=1>i", int), 2 | (1011 << 16), "12");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>i", int), 3, "13");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int), 3 | (3 << 16), "14");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>i", int), 2, "15a");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?i", int), 2, "15b");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int), 4 | (3 << 16), "18");

	ASSERT_EQ(sscanf("not-a-number", "i", int), 1, "9");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>i", int), 2, "10");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>i", int), SSCANF_ERROR(3, 1011), "11");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CODE_IN_RET=1>i", int), SSCANF_ERROR(2, 1011), "12");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>i", int), 3, "13");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int), SSCANF_ERROR(3, 3), "14");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>i", int), 2, "15a");
	ASSERT_EQ(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?i", int), 2, "15b");
	ASSERT_EQ(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int), SSCANF_ERROR(4, SSCANF_ERROR_INVALID), "18");

	ASSERT_EQ(sscanf("4 5 6", "ii", int, int), 0, "Unstrict");
	ASSERT_EQ(sscanf("4 5 6", "ii!", int, int), 3, "Strict");
	ASSERT_EQ(sscanf("4 5    ", "ii", int, int), 0, "Unstrict");
	ASSERT_EQ(sscanf("4 5    ", "ii!", int, int), 0, "Strict");
	ASSERT_EQ(sscanf("4 5 6", "?<ERROR_CODE_IN_RET=1>ii!", int, int), SSCANF_ERROR(4, 1009), "Code");

	new alt, a, b, c, d;
	ASSERT_EQ(sscanf("4 5", "bb|ii", alt, a, b, c, d), 0, "Alt 1a");
	ASSERT_EQ(alt, 2, "Alt 1b");
	ASSERT_EQ(c, 4, "Alt 1c");
	ASSERT_EQ(d, 5, "Alt 1d");

	ASSERT_EQ(sscanf("C C", "bb|ii", alt, a, b, c, d), 1, "Alt 2a");
	ASSERT_EQ(alt, 0, "Alt 2b");
	ASSERT_EQ(sscanf("C C", "bb|xx", alt, a, b, c, d), 0, "Alt 3a");
	ASSERT_EQ(alt, 2, "Alt 3b");
	ASSERT_EQ(c, 0xC, "Alt 3c");
	ASSERT_EQ(d, 0xC, "Alt 3d");

	ASSERT_EQ(sscanf("20 10", "xx|ii", alt, a, b, c, d), 0, "Alt 4a");
	ASSERT_EQ(alt, 1, "Alt 4b");
	ASSERT_EQ(a, 0x20, "Alt 4c");
	ASSERT_EQ(b, 0x10, "Alt 4d");

	switch (int)
	{
	case SSCANF_ERROR_NONE: {}
	case SSCANF_ERROR_NATIVE: {}
	case SSCANF_ERROR_SPECIFIER: {}
	case SSCANF_ERROR_INVALID: {}
	case (16 | _:SSCANF_ERROR_MISSING): {}
	case SSCANF_ERROR_EXCESS: {}
	case SSCANF_ERROR_COLOUR: {}
	case SSCANF_ERROR_OVERFLOW: {}
	case SSCANF_ERROR_NOT_FOUND: {}
	case SSCANF_ERROR_NO_ALTS: {}
	case SSCANF_ERROR(5, 6): {}
	case SSCANF_ERROR(7, 1001): {}
	case SSCANF_ERROR(8, SSCANF_ERROR_OVERFLOW): {}
	case SSCANF_ERROR(6, INVALID): {}
	case SSCANF_ERROR(1, NONE): {}
	case SSCANF_ERROR(1, NATIVE): {}
	case SSCANF_ERROR(1, SPECIFIER): {}
	case SSCANF_ERROR(1, INVALID): {}
	case SSCANF_ERROR(1, MISSING): {}
	case SSCANF_ERROR(1, EXCESS): {}
	case SSCANF_ERROR(1, COLOUR): {}
	case SSCANF_ERROR(1, OVERFLOW): {}
	case SSCANF_ERROR(1, NOT_FOUND): {}
	case SSCANF_ERROR(1, NO_ALTS): {}
	}

	Shop(0, "weapon 4 5");
	Shop(0, "armour");
	Shop(0, "health");
	Shop(0, "vehicle Infernus 5 6");
	Shop(0, "vehicle 500 9 10");
	Shop(0, "food");

	ASSERT_EQ(sscanf("hello", "i|f", alt, int, int), 1, "call");
	ASSERT_EQ(SSCANF_GetLastError(), 1016, "error");
	ASSERT_EQ(SSCANF_GetErrorSpecifier(), 3, "index");

	ASSERT_EQ(sscanf("2147483648", "i", a), 1, "Overflow (decimal)");
	ASSERT_EQ(sscanf("2147483647", "i", a), 0, "No overflow (decimal)");
	ASSERT_EQ(a, 2147483647, "No overflow (decimal)");
	ASSERT_EQ(sscanf("-2147483648", "i", a), 0, "No overflow (decimal)");
	ASSERT_EQ(a, -2147483648, "No overflow (decimal)");
	ASSERT_EQ(sscanf("-2147483649", "i", a), 1, "Overflow (decimal)");
	ASSERT_EQ(sscanf("4294967294", "i", a), 1, "Overflow (decimal)");

	ASSERT_EQ(sscanf("0x100000000", "x", a), 1, "Overflow (hex)");
	ASSERT_EQ(sscanf("0x80000000", "x", a), 1, "Overflow (hex)");
	ASSERT_EQ(sscanf("0x7FFFFFFF", "x", a), 0, "No overflow (hex)");
	ASSERT_EQ(a, 2147483647, "No overflow (hex)");
	ASSERT_EQ(sscanf("-0x80000000", "x", a), 0, "No overflow (hex)");
	ASSERT_EQ(a, -2147483648, "No overflow (hex)");

	ASSERT_EQ(sscanf("020000000000", "o", a), 1, "Overflow (octal)");
	ASSERT_EQ(sscanf("017777777777", "o", a), 0, "No overflow (octal)");
	ASSERT_EQ(a, 2147483647, "No overflow (octal)");
	ASSERT_EQ(sscanf("-020000000000", "o", a), 0, "No overflow (octal)");
	ASSERT_EQ(a, -2147483648, "No overflow (octal)");

	ASSERT_EQ(sscanf("2147483648", "n", a), 1, "Overflow (number, decimal)");
	ASSERT_EQ(sscanf("2147483647", "n", a), 0, "No overflow (number, decimal)");
	ASSERT_EQ(a, 2147483647, "No overflow (number, decimal)");
	ASSERT_EQ(sscanf("0x80000000", "n", a), 1, "Overflow (number, hex)");
	ASSERT_EQ(sscanf("0x7FFFFFFF", "n", a), 0, "No overflow (number, hex)");
	ASSERT_EQ(a, 2147483647, "No overflow (number, hex)");
}

#define COLOUR_ERROR (0xFF0000AA)
#define COLOUR_OK (0x00FF00AA)

Shop(playerid, const params[])
{
	new
		alt,
		weapon,
		ammo,
		vehicle,
		colour1,
		colour2;
	if (sscanf(params, "'weapon'ii|'armour'|'health'|'vehicle'k<vehicle>ii", alt, weapon, ammo, vehicle, colour1, colour2))
	{
		SendClientMessage(playerid, COLOUR_ERROR, "Usage:");
		SendClientMessage(playerid, COLOUR_ERROR, " ");
		SendClientMessage(playerid, COLOUR_ERROR, "	 /buy weapon <id> <ammo>");
		SendClientMessage(playerid, COLOUR_ERROR, "	 /buy armour");
		SendClientMessage(playerid, COLOUR_ERROR, "	 /buy health");
		SendClientMessage(playerid, COLOUR_ERROR, "	 /buy vehicle <type> <colour1> <colour2>");
		SendClientMessage(playerid, COLOUR_ERROR, " ");
		return 1;
	}
	else switch (alt)
	{
		case 1:
		{
			SendClientMessage(playerid, COLOUR_OK, "You bought weapon %d with %d ammo", weapon, ammo);
		}
		case 2:
		{
			SendClientMessage(playerid, COLOUR_OK, "You bought armour");
		}
		case 3:
		{
			SendClientMessage(playerid, COLOUR_OK, "You bought health");
		}
		case 4:
		{
			SendClientMessage(playerid, COLOUR_OK, "You bought vehicle %d with colours %d, %d", vehicle, colour1, colour2);
		}
	}
	return 1;
}
