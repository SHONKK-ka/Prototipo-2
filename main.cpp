#include <whb/proc.h>
#include <whb/log.h>
#include <whb/log_console.h>
#include <vpad/input.h>
#include <coreinit/foreground.h>

int main(int argc, char **argv)
{
    WHBProcInit();
    WHBLogConsoleInit();

    while(WHBProcIsRunning())
    {
        VPADStatus vpad;
        VPADReadError err;
        VPADRead(VPAD_CHAN_0, &vpad, 1, &err);

        WHBLogConsoleClear();
        WHBLogPrintf("UIU JUEGO - TODO BIEN!");
        WHBLogPrintf("");
        WHBLogPrintf("Si ves esto, compilo perfecto");
        WHBLogPrintf("");
        WHBLogPrintf("A = Salir");
        WHBLogPrintf("PLUS = Salir");
        WHBLogConsoleDraw();

        if(vpad.hold & VPAD_BUTTON_A) break;
        if(vpad.hold & VPAD_BUTTON_PLUS) break;
    }

    WHBLogConsoleShutdown();
    WHBProcShutdown();
    return 0;
}
