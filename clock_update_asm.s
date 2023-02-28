.text
.global  set_tod_from_secs
        
## ENTRY POINT FOR REQUIRED FUNCTION
set_tod_from_secs:
        
        cmp    $0, %edi      # if (time_of_day_sec < 0)
        jl      .ERROR
        
        cmp    $86400, %edi  # if (time_of_day_sec > 86400)
        jg      .ERROR  
        
        
        movl    %edi, %eax    # move time_of_day_sec to dividend (eax)
        
        cqto 
        
        movl    $3600, %ecx   # prepare divisor 
        
        idivl   %ecx
        movw    %ax, 0(%rsi)  # moving hours to tod->hours
        movl    %edx, %edi    # moving remainder into time_of_day_sec
       
        movl    %edi, %eax    # move time_of_day_sec to dividend (eax)
        cqto 
        movl    $60, %ecx     # prepare divisor
        idivl   %ecx 
        movw    %ax, 2(%rsi)  # moving minutes to tod->minutes
        movl    %edx, %edi    # moving remainder into time_of_day_sec

        movw    %dx, 4(%rsi)  # moving time_of_day_sec into tod->seconds

        movw    0(%rsi), %cx  # retreiving back tod->hours and assigning to hours
        
        cmp    $12, %ecx      # comparing hours with 12 
        jg      .GREATER      # jumps to .GREATER if hours > 12 

        cmp    $12, %ecx      # comparing hours with 12
        jl      .LESS         # jumps to .LESS if hours < 12

        cmp    $12, %ecx      # comparing hours with 12 
        je      .EQUAL        # jumps to .EQUAL if hours = 12 

.LAST:
        cmp    $0, %ecx      # comparing hours with 0
        je      .ZERO         # jumps to .ZERO if (tod->hours == 0)

        jmp     .RETURN

.GREATER:
        movb    $2, 6(%rsi)   # assigning 2 to tod->ampm
        subw    $12, 0(%rsi)  # tod->hours -= 12
        jmp     .LAST
    
.LESS: 
        movb    $1, 6(%rsi)   # assigning 1 to tod->ampm
        jmp     .LAST

.EQUAL:
        movb    $2, 6(%rsi)   # assigning 2 to tod->ampm
        jmp     .LAST

.ZERO: 
        movb    $1, 6(%rsi)   # assigning 1 to tod->ampm 
        movw    $12, 0(%rsi)  # assigning 12 to tod->hours 
        jmp     .RETURN 
        
.RETURN: 
        movl    $0, %eax      # success
        ret 

.ERROR:
        movl    $1, %eax      # error case 
        ret 

### Data area associated with t### Data area associated with the next function
.data
	
bit_masks:                         
        .int 0b0111111          # 0
        .int 0b0110000          # 1
        .int 0b1101101          # 2
        .int 0b1111001          # 3 
        .int 0b1110010          # 4 
        .int 0b1011011          # 5 
        .int 0b1011111          # 6 
        .int 0b0110001          # 7 
        .int 0b1111111          # 8 
        .int 0b1111011          # 9

other_int:                      # declare another accessible via name 'other_int'
        .int 0b0101             # binary value as per C '0b' convention

my_array:                       # declare multiple ints in a row 
        .int 10                 # for an array. Each are spaced
        .int 20                 # 4 bytes from each other
        .int 30


.text
.global  set_display_from_tod

## ENTRY POINT FOR REQUIRED FUNCTION
set_display_from_tod:
        ## assembly instructions here


        movq    %rdi, %rdx              # extract hours
        andq    $0xFF,%rdx              # rdx = hours, mask low byte
        movq    %rdx, %r8               # store hours in r8

        movq    %rdi, %rdx              # extract minutes
        sarq    $16, %rdx               # move minutes to low order bits
        andq    $0xFF,%rdx              # rdx = minutes, mask low byte
        movq    %rdx, %r9               # store minutes in r9

        movq    %rdi, %rdx              # extract seconds      
        sarq    $32, %rdx               # move seconds to low order bits
        andq    $0xFF,%rdx              # rdx = seconds, mask low byte
        movq    %rdx, %r10              # store seconds in r10

        cmp     $0, %r8                 # comparing hours with 0
        jl      .ERROR2
        cmp     $24, %r8                # comparing hours with 24
        jg      .ERROR2
        cmp     $0, %r9                 # comparing minutes with 0
        jl      .ERROR2
        cmp     $59, %r9                # comparing minutes with 0
        jg      .ERROR2
        cmp     $0, %r10                # comparing seconds with 0
        jl      .ERROR2
        cmp     $86400, %r10            # comparing seconds with 86400
        jg      .ERROR2


        

        movq    %r9, %rax               # move minutes to divided (rax)
        cqto
        movq    $10, %rcx               # prepare divisor 
        idivq   %rcx            
        movq    %rdx, %r10              # move remainder into min_ones
        movq    %rax, %r11              # move quotient into mins_tens

        movq    %r8, %rax               # move hours to divided (rax)
        cqto
        movq    $10, %rcx               # prepare divisor 
        idivq   %rcx            
        movq    %rdx, %r8               # move remainder into hour_ones
        movq    %rax, %r9               # move quotient into hour_tens

        # r10 = min_ones
        # r11 = min_tens
        # r8 = hour_ones
        # r9 = hour_tens

        movq    $0, %rdx                # rdx is set which holds value 0 

        leaq    bit_masks(%rip), %rcx   # load pointer to beginning of bit_masks into rcx

        movq    (%rcx, %r10, 4), %rax   # rax = array[r10] retreivng min_ones_bit
        orq     %rax, %rdx              # set = set | min_ones_bit

        leaq    bit_masks(%rip), %rcx   # load pointer to beginning of bit_masks into rcx

        movq    (%rcx, %r11, 4), %rax   # rax = array[r11] retreiving min_tens_bit
        salq    $7, %rax                # min_tens_bit = min_tens_bit << 7
        orq      %rax, %rdx              # set = set | min_tens_bit 

        leaq    bit_masks(%rip), %rcx   # load pointer to beginning of bit_masks into rcx

        movq    (%rcx, %r8, 4), %rax    # rax = array[r8] retreiving hour_ones_bit
        salq    $14, %rax               # hour_ones_bit = hour_ones_bit << 14
        or      %rax, %rdx              # set = set | hour_ones_bit 

        cmp     $0, %r9                 # comparing hour_tens with 0 
        jne     .NOT_ZERO
        jmp     .AMPM 

.NOT_ZERO:
        movq    (%rcx, %r9, 4), %rax    # rax = bit_masks[r9] retreiving hour_tens_bit 
        salq    $21, %rax               # hour_tens_bit = hour_tens_bit << 21 
        orq     %rax, %rdx              # set = set | hour_tens_bit
        jmp     .AMPM                   

.AMPM: 
        movq    %rdi, %r11              # extract ampm
        sarq    $48, %r11               # move ampm to low order bits
        andq    $0xFF,%r11              # r11 = ampm, mask low byte
        movq    %r11, %r9               # store ampm in r9
        cmp     $1, %r9 
        je      .AM
        jl      .ERROR2
        cmp     $2, %r9
        je      .PM
        jg      .ERROR2


.AM:
        movq    $1, %r8                 # moving 1 into r8 
        salq    $28, %r8                # 1 << 28
        orq     %r8, %rdx               # set = set | (%r8)
        jmp     .RETURN2 

.PM:
        movq    $1, %r8
        salq    $29, %r8
        orq     %r8, %rdx             # set = set | (%r8)
        jmp     .RETURN2

.RETURN2:
        movl    %edx, (%rsi)            # *display = set
        movl    $0, %eax                # success
        ret 

.ERROR2:
        movl    $1, %eax                # error case 
        ret     

.text
.global clock_update
        
## ENTRY POINT FOR REQUIRED FUNCTION
clock_update:
	## assembly instructions here
        push    $0                             # constant in 0 for stack 
        
        movl    TIME_OF_DAY_SEC(%rip), %edi    # copy global var to reg edx
        movq    %rsp, %rsi                     # &tod
        
        call    set_tod_from_secs              # call function

        cmp     $0, %rax 
        jne      .ERROR3

        movq    (%rsp), %rdi                   # extracting tod 
        movq    %rsp, %rsi 
        call    set_display_from_tod

        cmp     $0, %rax
        jne      .ERROR3

        popq    %rdx 
        movl    %edx, CLOCK_DISPLAY_PORT(%rip) 

        movl    $0, %eax
        ret 

.ERROR3:
        popq    %rdx
        movl    $1, %eax
        ret



	


