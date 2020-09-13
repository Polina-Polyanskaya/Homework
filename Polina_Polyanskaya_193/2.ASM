;Разбор примеров из папки Examles
;Испольвание MessageBox - при ответе "Yes" выводится на экран фраза, при ответе "Нет" всё закрывается.


; example of simplified Windows programming using complex macro features

include 'win32ax.inc' ; you can simply switch between win32ax, win32wx, win64ax and win64wx here

.code

  start:

        invoke  MessageBox,HWND_DESKTOP,"Do you like programming?",invoke GetCommandLine,MB_YESNO

        .if eax = IDYES
                invoke  MessageBox,HWND_DESKTOP,"Let's study assembler together!","Message",MB_OK
        .endif

        invoke  ExitProcess,0


.end start
