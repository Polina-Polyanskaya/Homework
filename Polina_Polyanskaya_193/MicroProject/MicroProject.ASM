;Примечание: считаю, что вводится строка длиной не больше 255 символов.
;Полянская Полина БПИ193 1 подгруппа
;Разработать программу, которая на основе заданной  ASCII-строки символов, решает вопрос,   является   ли   данная   строка палиндромом
;17 вариант

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
input db 'Write string',10,0
 ; строка, чтобы вывести  перевернутую строку 
formatStr db '%s', 0 ; для считывания строки с консоли
thisString db 'Your string is: %s',10,0
 ; строка, чтобы вывести  исходную строку 
oppositeString db 'The opposite string is: %s',10,0
 ; строка, чтобы вывести  перевернутую строку 
palindrom db 'This is palindrom!',10,0
 ; строка, чтобы сообщить о том, что исходная строка -  палиндром 
notPalindrom db 'This is not a palindrom!',10,0
 ; строка, чтобы сообщить о том, что исходная строка -  не палиндром 
nm rb 256 ; исходная строка
nm2 rb 256 ; перевернутая строка

;--------------------------------------------------------------------------
; Main program
section '.code' code readable executable
start:
        push input 
        call [printf]
        add esp, 4
        push nm  ;считываем строку с консоли
        push formatStr
        call[scanf]
        add esp, 8
        push nm ; выводим исходную строку
        push thisString
        call [printf]
        add esp, 8
        stdcall strcpy, nm, nm2 ; переворачиваем исходную строку
        push nm2
        push oppositeString
        call [printf] ; выводим перевернутую строку
        stdcall  streq, nm,nm2
        ; сравниваем строки
        cmp eax, 0 ;если значение в eax = 0, то переходим по метке NotPalindrom
        je NotPalindrom
        cmp eax,1 ; если значение в eax =1, то переходим по метке Palindrom
        je Palindrom

;--------------------------------------------------------------------------

Palindrom:
push palindrom 
call[printf] ;выводим строку, о том, что строка - палиндром
add esp,4
jmp finish ; переходим на метку finish

NotPalindrom:
push notPalindrom
call[printf] ; выводим строку, о том, что строка - не палиндром
add esp,4
jmp finish ; переходим на метку finish

finish:
call [getch] ; при введении пользователем символа - завершаем программу
push 0
call [ExitProcess]

strcpy:
    mov     esi, [esp+4]
    mov     edi, esi
    mov     edx, [esp+8]

    mov ecx,-1
    xor al, al ; al=0
    cld ; направление от начала до конца
    repne   scasb
    sub edi, 2
    neg ecx
    sub ecx,2

    mov esi,edi
    mov edi,edx

loopstrcpy:
    mov al, [esi]
    mov [edi], al
    sub esi,1
    add edi,1
    cmp ecx,0
    jle endloopstrcpy  ; если значение в ecx меньше или равно 0, то переходим по метке endloopstrcpy 
    sub ecx,1
    jmp loopstrcpy ; переходим по метке loopstrcpy

endloopstrcpy:
    xor eax,eax ; eax=0
    mov [edi],al
    ret ; возвращаемся

streq:
    mov     esi, [esp+4]
    mov     edi, [esp+8]
    cld      ; направление от начала до конца
    xor     eax, eax ; eax=0
loopStrEq:
    cmp     al, [esi]
    je      endSrc ; если al=[esi], то переходим по метке endSrc
    cmp     al, [edi]
    je      isNe ; если al=[edi], то переходим по метке isNe
    cmpsb
    je      loopStrEq
    jmp     isNe ; переходим по метке isNe
endSrc:
    cmp     al, [edi]
    je      isEq ;если al=[edi], то переходим по метке isEq
    jmp     isNe ; переходим по метке isNe
isEq:
    mov eax, 1 ; перемещаем в eax 1
    ret ; возвращаемся
isNe:
    mov eax, 0  ; перемещаем в eax 0
    ret ; возвращаемся
;--------------------------------------------------------------------------
; Including External Api
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

include 'api\kernel32.inc'

    import kernel,\
           ExitProcess, 'ExitProcess'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'    



