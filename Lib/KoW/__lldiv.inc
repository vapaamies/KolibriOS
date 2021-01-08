procedure __lldiv; // needed for FastMM under Windows, copied from CodeGear
asm
        push    ebp
        push    ebx
        push    esi
        push    edi
        xor     edi,edi

        mov     ebx,20[esp]     
        mov     ecx,24[esp]     

        or      ecx,ecx
        jnz     @@slow_ldiv     

        or      edx,edx
        jz      @@quick_ldiv

        or      ebx,ebx
        jz      @@quick_ldiv    

@@slow_ldiv:
        or      edx,edx
        jns     @@onepos
        neg     edx
        neg     eax
        sbb     edx,0           
        or      edi,1

@@onepos:
        or      ecx,ecx         
        jns     @@positive
        neg     ecx
        neg     ebx
        sbb     ecx,0           
        xor edi,1

@@positive:
        mov     ebp,ecx
        mov     ecx,64          
        push    edi             
        xor     edi,edi         
        xor     esi,esi

@@xloop:
        shl     eax,1           
        rcl     edx,1
        rcl     esi,1
        rcl     edi,1
        cmp     edi,ebp         
        jb      @@nosub
        ja      @@subtract
        cmp     esi,ebx         
        jb      @@nosub

@@subtract:
        sub     esi,ebx
        sbb     edi,ebp         
        inc     eax             

@@nosub:
        loop    @@xloop
        pop     ebx             
        test    ebx,1           
        jz      @@finish
        neg     edx
        neg     eax
        sbb     edx,0           

@@finish:
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret     8

@@quick_ldiv:
        div     ebx             
        xor     edx,edx
        jmp     @@finish
end;