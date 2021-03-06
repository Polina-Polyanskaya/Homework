;����������: ������, ��� �������� ������ ������ �� ������ 255 ��������.
;��������� ������ ���193 1 ���������
;����������� ���������, ������� �� ������ ��������  ASCII-������ ��������, ������ ������,   ��������   ��   ������   ������ �����������
;17 �������

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
input db 'Write string',10,0
 ; ������, ����� �������  ������������ ������ 
formatStr db '%s', 0 ; ��� ���������� ������ � �������
thisString db 'Your string is: %s',10,0
 ; ������, ����� �������  �������� ������ 
oppositeString db 'The opposite string is: %s',10,0
 ; ������, ����� �������  ������������ ������ 
palindrom db 'This is palindrom!',10,0
 ; ������, ����� �������� � ���, ��� �������� ������ -  ��������� 
notPalindrom db 'This is not a palindrom!',10,0
 ; ������, ����� �������� � ���, ��� �������� ������ -  �� ��������� 
nm rb 256 ; �������� ������
nm2 rb 256 ; ������������ ������

;--------------------------------------------------------------------------
; Main program
section '.code' code readable executable
start:
        push input 
        call [printf]
        add esp, 4
        push nm  ;��������� ������ � �������
        push formatStr
        call[scanf]
        add esp, 8
        push nm ; ������� �������� ������
        push thisString
        call [printf]
        add esp, 8
        stdcall strcpy, nm, nm2 ; �������������� �������� ������
        push nm2
        push oppositeString
        call [printf] ; ������� ������������ ������
        stdcall  streq, nm,nm2
        ; ���������� ������
        cmp eax, 0 ;���� �������� � eax = 0, �� ��������� �� ����� NotPalindrom
        je NotPalindrom
        cmp eax,1 ; ���� �������� � eax =1, �� ��������� �� ����� Palindrom
        je Palindrom

;--------------------------------------------------------------------------

Palindrom:
push palindrom 
call[printf] ;������� ������, � ���, ��� ������ - ���������
add esp,4
jmp finish ; ��������� �� ����� finish

NotPalindrom:
push notPalindrom
call[printf] ; ������� ������, � ���, ��� ������ - �� ���������
add esp,4
jmp finish ; ��������� �� ����� finish

finish:
call [getch] ; ��� �������� ������������� ������� - ��������� ���������
push 0
call [ExitProcess]

strcpy:
    mov     esi, [esp+4]
    mov     edi, esi
    mov     edx, [esp+8]

    mov ecx,-1
    xor al, al ; al=0
    cld ; ����������� �� ������ �� �����
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
    jle endloopstrcpy  ; ���� �������� � ecx ������ ��� ����� 0, �� ��������� �� ����� endloopstrcpy 
    sub ecx,1
    jmp loopstrcpy ; ��������� �� ����� loopstrcpy

endloopstrcpy:
    xor eax,eax ; eax=0
    mov [edi],al
    ret ; ������������

streq:
    mov     esi, [esp+4]
    mov     edi, [esp+8]
    cld      ; ����������� �� ������ �� �����
    xor     eax, eax ; eax=0
loopStrEq:
    cmp     al, [esi]
    je      endSrc ; ���� al=[esi], �� ��������� �� ����� endSrc
    cmp     al, [edi]
    je      isNe ; ���� al=[edi], �� ��������� �� ����� isNe
    cmpsb
    je      loopStrEq
    jmp     isNe ; ��������� �� ����� isNe
endSrc:
    cmp     al, [edi]
    je      isEq ;���� al=[edi], �� ��������� �� ����� isEq
    jmp     isNe ; ��������� �� ����� isNe
isEq:
    mov eax, 1 ; ���������� � eax 1
    ret ; ������������
isNe:
    mov eax, 0  ; ���������� � eax 0
    ret ; ������������
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



