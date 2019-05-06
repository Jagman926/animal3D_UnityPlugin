#include "stdafx.h"
#include "foo.h"

extern "C"
{
	int FOO_API foo()
	{
		return 26;
	}
}