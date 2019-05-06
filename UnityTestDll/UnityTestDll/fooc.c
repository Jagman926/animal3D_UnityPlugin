#include "stdafx.h"

#ifdef UNITYTESTDLL_EXPORTS
#define FOO_API __declspec(dllexport)
#else
#define FOO_API __declspec(dllimport)
#endif

#ifdef __cplusplus
extern "C"
{
#endif
	int FOO_API foo();

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
extern "C"
{
#endif
	int  foo()
	{
		return 26;
	}
#ifdef __cplusplus
}
#endif
