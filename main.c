#include <stdio.h>
#include "HsFFI.h"
#include "FFI_stub.h"
extern void __stginit_FFI(void);

int main(int argc,char* argv[])
{
	hs_init(&argc,&argv);
	hs_add_root(__stginit_FFI);
	HsStablePtr x = hGetCommands("play 36\nstop");
	printf("playing number is (%d)\n",hIsPlay(hTakeToken(x,0)));

	hs_free_stable_ptr(x);
	hs_exit();
	return 0;
}
