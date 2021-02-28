#if !defined HEADER_GUARD_ArrayCopy
#    define  HEADER_GUARD_ArrayCopy 1


#define ArrayCopy_FromChars_cnst 0
#define ArrayCopy_FromBytes_cnst 1
#define ArrayCopy_ToChars_cnst 0
#define ArrayCopy_ToBytes_cnst 2

#define ArrayCopy_FromCharsToChars_cnst 0
#define ArrayCopy_FromCharsToBytes_cnst 2
#define ArrayCopy_FromBytesToChars_cnst 1
#define ArrayCopy_FromBytesToBytes_cnst 3

extern void ArrayCopy_Chars(o7_int_t dest_len0, o7_char dest[/*len0*/], o7_int_t destOfs, o7_int_t src_len0, o7_char src[/*len0*/], o7_int_t srcOfs, o7_int_t count);

extern void ArrayCopy_Bytes(o7_int_t dest_len0, char unsigned dest[/*len0*/], o7_int_t destOfs, o7_int_t src_len0, char unsigned src[/*len0*/], o7_int_t srcOfs, o7_int_t count);

extern void ArrayCopy_CharsToBytes(o7_int_t dest_len0, char unsigned dest[/*len0*/], o7_int_t destOfs, o7_int_t src_len0, o7_char src[/*len0*/], o7_int_t srcOfs, o7_int_t count);

extern void ArrayCopy_BytesToChars(o7_int_t dest_len0, o7_char dest[/*len0*/], o7_int_t destOfs, o7_int_t src_len0, char unsigned src[/*len0*/], o7_int_t srcOfs, o7_int_t count);

extern void ArrayCopy_Data(o7_int_t direction, o7_int_t destBytes_len0, char unsigned destBytes[/*len0*/], o7_int_t destChars_len0, o7_char destChars[/*len0*/], o7_int_t destOfs, o7_int_t srcBytes_len0, char unsigned srcBytes[/*len0*/], o7_int_t srcChars_len0, o7_char srcChars[/*len0*/], o7_int_t srcOfs, o7_int_t count);

#endif
