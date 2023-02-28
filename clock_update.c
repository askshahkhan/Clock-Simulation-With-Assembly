#include "clock.h"

// int set_tod_from_secs(int time_of_day_sec, tod_t *tod){
//     if (time_of_day_sec < 0 || time_of_day_sec > 86400) { // ERROR CHECKING
//         return 1; 
//     }
//     // SETTING TIME OF DAY FOR HOURS, MINUTES, SECONDS, AMPM:
//     tod->hours = time_of_day_sec / 3600;
//     time_of_day_sec = time_of_day_sec % 3600;
//     tod->minutes = time_of_day_sec / 60;
//     time_of_day_sec = time_of_day_sec % 60;
//     tod->seconds = time_of_day_sec;
//     if (tod->hours > 12) {
//         tod->ampm = 2;
//         tod->hours -= 12; 
//     }
//     else if (tod->hours == 12) {
//         tod->ampm = 2;
//     }
//     else {
//         tod->ampm = 1;
//     }
//     if (tod->hours == 0) {
//         tod->ampm = 1;
//         tod->hours = 12; 
//     }
//     return 0; 
// }
// Accepts time of day in seconds as an argument and modifies the
// struct pointed at by tod to fill in its hours, minutes,
// etc. fields.  If time_of_day_sec is invalid (negative or larger
// than the number of seconds in a day) does nothing to tod and
// returns 1 to indicate an error. Otherwise returns 0 to indicate
// success. This function DOES NOT modify any global variables
//
// CONSTRAINT: Uses only integer operations. No floating point
// operations are used as the target machine does not have a FPU.
// 
// CONSTRAINT: Limit the complexity of code as much as possible. Do
// not use deeply nested conditional structures. Seek to make the code
// as short, and simple as possible. Code longer than 40 lines may be
// penalized for complexity.

// int set_display_from_tod(tod_t tod, int *display){
//     if (tod.minutes < 0 || tod.minutes > 59 || tod.hours > 24 || tod.hours < 0 || tod.seconds < 0 || tod.seconds > 86400) { // ERROR CHECKING
//         return 1; 
//     }
//     int bit_masks[10] = { // BIT MASKS FOR 0-9
//         0b0111111, 0b0110000, 0b1101101, 0b1111001, 0b1110010, 
//         0b1011011, 0b1011111, 0b0110001, 0b1111111, 0b1111011};
//     // SETTING DIGITS FOR CLOCK
//     int min_ones = (tod.minutes) % 10;
//     int min_tens = (tod.minutes) / 10;
//     int hour_ones = (tod.hours) % 10;
//     int hour_tens = (tod.hours) / 10; 

//     int set = 0; // state variable of zero (all 0 bits)

//     set = set | bit_masks[min_ones]; 
//     // SETTING BITS AND UPDATING SET (STATE VARIABLE)
//     int min_tens_bit = bit_masks[min_tens]; 
//     min_tens_bit = min_tens_bit << 7; 
//     set = set | min_tens_bit;

//     int hour_ones_bit = bit_masks[hour_ones];
//     hour_ones_bit = hour_ones_bit << 14; 
//     set = set | hour_ones_bit;

//     if (hour_tens != 0) {
//         int hour_tens_bit = bit_masks[hour_tens];
//         hour_tens_bit = hour_tens_bit << 21;
//         set = set | hour_tens_bit;
//     }

    // if (tod.ampm == 1) {
    //     set = set | (1 << 28);
    // }
    // else {
    //     set = set | (1 << 29); 
    // }
//     *display = set; // UPDATING DISPLAY
//     return 0;
// }
// // Accepts a tod and alters the bits in the int pointed at by display
// // to reflect how the clock should appear. If any fields of tod are
// // negative or too large (e.g. bigger than 12 for hours, bigger than
// // 59 for min/sec), no change is made to display and 1 is returned to
// // indicate an error. Otherwise returns 0 to indicate success. This
// // function DOES NOT modify any global variables
// //
// // May make use of an array of bit masks corresponding to the pattern
// // for each digit of the clock to make the task easier.
// // 
// // CONSTRAINT: Limit the complexity of code as much as possible. Do
// // not use deeply nested conditional structures. Seek to make the code
// // as short, and simple as possible. Code longer than 85 lines may be
// // penalized for complexity.
// // 43 / 10 = 4
// // 43 % 10 = 3


// int clock_update(){
//     tod_t tod; 
//     if (TIME_OF_DAY_SEC < 0 || TIME_OF_DAY_SEC > 86400) { // ERROR CHECKING
//         return 1;
//     }
//     else { // UTLIZING HELPER FUNCTIONS TO SET TOD AND SET DISPLAY FROM TOD
//         set_tod_from_secs(TIME_OF_DAY_SEC, &tod);
//         set_display_from_tod(tod, &CLOCK_DISPLAY_PORT);
//         return 0;
//     }
    
    
// }
// Examines the TIME_OF_DAY_SEC global variable to determine hour,
// minute, and am/pm.  Sets the global variable CLOCK_DISPLAY_PORT bits
// to show the proper time.  If TIME_OF_DAY_SEC appears to be in error
// (to large/small) makes no change to CLOCK_DISPLAY_PORT and returns 1
// to indicate an error. Otherwise returns 0 to indicate success.
//
// Makes use of the set_tod_from_secs() and
// set_display_bits_from_tod() functions.
// 
// CONSTRAINT: Does not allocate any heap memory as malloc() is NOT
// available on the target microcontroller.  Uses stack and global
// memory only.