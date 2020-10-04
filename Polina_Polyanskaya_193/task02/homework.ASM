;Разработать программу, которая вводит одномерный массив A[N], формирует их элементов массива А новый массив В
;по правилу: расположенных после последнего положительного элемента и выводит его. Память под массивы может выделяться
;как статически, так и динамически по выбору разработчика.
;17 вариант

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable
        strWrong   db 'There are no positive numbers', 0
        strVecSize   db 'size of vector? ', 0
        strIncorSize db 'Incorrect size of vector = %d ', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '[%d] = %d', 10, 0

        vec_size     dd 0
        i            dd ?
        i2           dd -1
        num          dd ?
        tmp          dd ?
        tmp2         dd ?
        tmpStack     dd ?
        tmpStack2    dd ?
        vec          rd 100
        vec2         rd 100
;--------------------------------------------------------------------------
section '.code' code readable executable
start:

        call VectorInput

finish:
        call [getch]
        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:

        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]

        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector

; fail size

        push [vec_size]
        push strIncorSize
        call [printf]
        call finish

getVector:
        xor ecx, ecx
        mov ebx, vec

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector

        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]

        mov edx,[ebx]
        cmp edx,0
        jg getnum

getVecLoop2:
        add esp, 8
        mov ecx,[i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop

endInputVector:
        add esp, 4
        call VectorFirstOut
        cmp [i2], -1
        je wrong
        call CreateVector
        call finish
wrong:
     push strWrong
     call[printf]
     call finish

getnum:
       mov edx,[i]
       mov [i2],edx
       jmp getVecLoop2


CreateVector:
        xor ecx, ecx
        mov ebx, vec
        mov edx, vec2

putVec2:
        cmp ecx, [i2]
        jg next
        inc ecx
        add ebx,4
        jmp putVec2

next:
        cmp ecx, [vec_size]
        jge endPutVec2
        mov eax, [ebx]
        mov [edx], eax
        add ebx,4
        add edx,4
        inc ecx
        jmp next


endPutVec2:
        dec ecx
        sub ecx,[i2]
        mov [num], ecx
        mov [tmpStack2], esp

        xor ecx, ecx
        mov ebx, vec2

putOutNewVec:
        mov [tmp2], ebx
        cmp ecx, [num]
        je endOutputNewVector

        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp2]
        add ebx, 4
        jmp putOutNewVec

endOutputNewVector:
        mov esp, [tmpStack2]
        ret


VectorFirstOut:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec

putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector

        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop

endOutputVector:
        mov esp, [tmpStack]
        ret

;--------------------------------------------------------------------------

                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'