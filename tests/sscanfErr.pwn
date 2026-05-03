#define SSCANF_NO_NICE_FEATURES

#include <a_samp>
#include <sscanf2>

ASSERT(bool:test, const message[])
{
	if (!test)
	{
		printf("SSCANF test failed: %s", message);
	}
}

main()
{
	SSCANF_Option(SSCANF_QUIET, 1);

	ASSERT(SSCANF_GetErrorCategory(1004) == SSCANF_ERROR_MISSING, "SSCANF_ERROR_MISSING");
	ASSERT(SSCANF_GetErrorCategory(1009) == SSCANF_ERROR_EXCESS, "SSCANF_ERROR_EXCESS");
	ASSERT(SSCANF_GetErrorCategory(1001) == SSCANF_ERROR_COLOUR, "SSCANF_ERROR_COLOUR");
	ASSERT(SSCANF_GetErrorCategory(2) == SSCANF_ERROR_OVERFLOW, "SSCANF_ERROR_OVERFLOW");
	ASSERT(SSCANF_GetErrorCategory(1003) == SSCANF_ERROR_NOT_FOUND, "SSCANF_ERROR_NOT_FOUND");
	ASSERT(SSCANF_GetErrorCategory(1010) == SSCANF_ERROR_NO_ALTS, "SSCANF_ERROR_NO_ALTS");

	new str[8];
	ASSERT(sscanf("this-is-a-too-long-string", "s[8]", str) == 0, "1");
	ASSERT(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>s[8]", str) == 2, "2");
	ASSERT(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>s[8]", str) == 3 | (2 << 16), "3");
	ASSERT(sscanf("this-is-a-too-long-string", "?<ERROR_CODE_IN_RET=1>s[8]", str) == 0, "4");
	ASSERT(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>s[8]", str) == 3, "5");
	ASSERT(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>s[8]", str) == 0, "6");
	ASSERT(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>s[8]", str) == 0, "7a");
	ASSERT(sscanf("this-is-a-too-long-string", "?<ERROR_CATEGORY_ONLY=1>?s[8]", str) == 2, "7b");
	ASSERT(sscanf("this-is-a-too-long-string", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>s[8]", str) == 4 | (7 << 16), "8");

	new int;
	ASSERT(sscanf("not-a-number", "i", int) == 1, "9");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>i", int) == 2, "10");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>i", int) == 3 | (1011 << 16), "11");
	ASSERT(sscanf("not-a-number", "?<ERROR_CODE_IN_RET=1>i", int) == 2 | (1011 << 16), "12");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>i", int) == 3, "13");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int) == 3 | (3 << 16), "14");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>i", int) == 2, "15a");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?i", int) == 2, "15b");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int) == 4 | (3 << 16), "18");

	ASSERT(sscanf("not-a-number", "i", int) == 1, "9");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>i", int) == 2, "10");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CODE_IN_RET=1>i", int) == SSCANF_ERROR(3, 1011), "11");
	ASSERT(sscanf("not-a-number", "?<ERROR_CODE_IN_RET=1>i", int) == SSCANF_ERROR(2, 1011), "12");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>i", int) == 3, "13");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int) == SSCANF_ERROR(3, 3), "14");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>i", int) == 2, "15a");
	ASSERT(sscanf("not-a-number", "?<ERROR_CATEGORY_ONLY=1>?i", int) == 2, "15b");
	ASSERT(sscanf("not-a-number", "?<WARNINGS_AS_ERRORS=1>?<ERROR_CATEGORY_ONLY=1>?<ERROR_CODE_IN_RET=1>i", int) == SSCANF_ERROR(4, SSCANF_ERROR_INVALID), "18");

	ASSERT(sscanf("4 5 6", "ii", int, int) == 0, "Unstrict");
	ASSERT(sscanf("4 5 6", "ii!", int, int) == 3, "Strict");
	ASSERT(sscanf("4 5    ", "ii", int, int) == 0, "Unstrict");
	ASSERT(sscanf("4 5    ", "ii!", int, int) == 0, "Strict");
	ASSERT(sscanf("4 5 6", "?<ERROR_CODE_IN_RET=1>ii!", int, int) == SSCANF_ERROR(4, 1009), "Code");

	new alt, a, b, c, d;
	ASSERT(sscanf("4 5", "bb|ii", alt, a, b, c, d) == 0, "Alt 1a");
	ASSERT(alt == 2, "Alt 1b");
	ASSERT(c == 4, "Alt 1c");
	ASSERT(d == 5, "Alt 1d");

	ASSERT(sscanf("C C", "bb|ii", alt, a, b, c, d) == 1, "Alt 2a");
	ASSERT(alt == 0, "Alt 2b");
	ASSERT(sscanf("C C", "bb|xx", alt, a, b, c, d) == 0, "Alt 3a");
	ASSERT(alt == 2, "Alt 3b");
	ASSERT(c == 0xC, "Alt 3c");
	ASSERT(d == 0xC, "Alt 3d");

	ASSERT(sscanf("20 10", "xx|ii", alt, a, b, c, d) == 0, "Alt 4a");
	ASSERT(alt == 1, "Alt 4b");
	ASSERT(a == 0x20, "Alt 4c");
	ASSERT(b == 0x10, "Alt 4d");

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

	ASSERT(sscanf("hello", "i|f", alt, int, int) == 1, "call");
	ASSERT(SSCANF_GetLastError() == 1016, "error");
	ASSERT(SSCANF_GetErrorSpecifier() == 3, "index");
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
