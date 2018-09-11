/* Generated by Vostok - Oberon-07 translator */

#define O7_BOOL_UNDEFINED
#include <o7.h>

#include "VDataStream.h"

#define VDataStream_In_tag V_Base_tag
extern void VDataStream_In_undef(struct VDataStream_In *r) {
	V_Base_undef(&r->_);
	r->read = NULL;
	r->readChars = NULL;
}
#define VDataStream_Out_tag V_Base_tag
extern void VDataStream_Out_undef(struct VDataStream_Out *r) {
	V_Base_undef(&r->_);
	r->write = NULL;
	r->writeChars = NULL;
}

extern void VDataStream_InitIn(struct VDataStream_In *in_, VDataStream_ReadProc read, VDataStream_ReadCharsProc readChars) {
	V_Init(&(*in_)._);
	(*in_).read = read;
	(*in_).readChars = readChars;
}

extern int VDataStream_Read(struct VDataStream_In *in_, o7_tag_t in__tag, int buf_len0, char unsigned buf[/*len0*/], int ofs, int count) {
	int r;

	O7_ASSERT((0 <= ofs) && (0 <= count) && (ofs <= o7_sub(buf_len0, count)));
	r = (*in_).read(&(*in_)._, in__tag, buf_len0, buf, ofs, count);
	O7_ASSERT((0 <= r) && (r <= count));
	return r;
}

extern int VDataStream_ReadChars(struct VDataStream_In *in_, o7_tag_t in__tag, int buf_len0, o7_char buf[/*len0*/], int ofs, int count) {
	int r;

	O7_ASSERT((0 <= ofs) && (0 <= count) && (ofs <= o7_sub(buf_len0, count)));
	r = (*in_).readChars(&(*in_)._, in__tag, buf_len0, buf, ofs, count);
	O7_ASSERT((0 <= r) && (r <= count));
	return r;
}

extern void VDataStream_InitOut(struct VDataStream_Out *out, VDataStream_WriteProc write, VDataStream_WriteCharsProc writeChars) {
	V_Init(&(*out)._);
	(*out).write = write;
	(*out).writeChars = writeChars;
}

extern int VDataStream_Write(struct VDataStream_Out *out, o7_tag_t out_tag, int buf_len0, char unsigned buf[/*len0*/], int ofs, int count) {
	int w;

	O7_ASSERT((0 <= ofs) && (0 <= count) && (ofs <= o7_sub(buf_len0, count)));
	w = (*out).write(&(*out)._, out_tag, buf_len0, buf, ofs, count);
	O7_ASSERT((0 <= w) && (w <= count));
	return w;
}

extern int VDataStream_WriteChars(struct VDataStream_Out *out, o7_tag_t out_tag, int buf_len0, o7_char buf[/*len0*/], int ofs, int count) {
	int w;

	O7_ASSERT((0 <= ofs) && (0 <= count) && (ofs <= o7_sub(buf_len0, count)));
	w = (*out).writeChars(&(*out)._, out_tag, buf_len0, buf, ofs, count);
	O7_ASSERT((0 <= w) && (w <= count));
	return w;
}
