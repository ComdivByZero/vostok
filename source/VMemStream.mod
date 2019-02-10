(* Copyright 2019 ComdivByZero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)
MODULE VMemStream;

  IMPORT V, Stream := VDataStream, ArrayCopy;

  CONST Size* = 256;

  TYPE
    Block = POINTER TO RBlock;
    RBlock = RECORD
      data: ARRAY Size OF BYTE;
      next: Block
    END;
    ROut* = RECORD(Stream.Out)
      first, last: Block;
      ofs: INTEGER
    END;
    Out* = POINTER TO ROut;

    RIn* = RECORD(Stream.In)
      block: Block;
      ofs, end, last: INTEGER
    END;
    In* = POINTER TO RIn;

    Handle* = PROCEDURE(ctx: V.Base; data: ARRAY OF BYTE; len: INTEGER): BOOLEAN;

  PROCEDURE AddBlock(VAR out: ROut): BOOLEAN;
  VAR ok: BOOLEAN;
  BEGIN
    NEW(out.last.next);
    ok := out.last.next # NIL;
    IF ok THEN
      out.last := out.last.next;
      out.last.next := NIL
    END
  RETURN
    ok
  END AddBlock;

  PROCEDURE Write(VAR out: V.Base; buf: ARRAY OF BYTE; ofs, count: INTEGER)
                 : INTEGER;

    PROCEDURE Copy(VAR out: ROut; buf: ARRAY OF BYTE; ofs, count: INTEGER): INTEGER;
    VAR rest: INTEGER;
    BEGIN
      rest := count;
      IF rest > Size - out.ofs THEN
        IF out.ofs # Size THEN
          ArrayCopy.Bytes(out.last.data, out.ofs, buf, ofs, Size - out.ofs);
          ofs := ofs + (Size - out.ofs);
          rest := rest - (Size - out.ofs)
        END;
        out.ofs := 0;
        WHILE AddBlock(out) & (rest >= Size) DO
          ArrayCopy.Bytes(out.last.data, 0, buf, ofs, Size);
          INC(ofs, Size);
          DEC(rest, Size)
        END
      END;
      IF rest > 0 THEN
        ArrayCopy.Bytes(out.last.data, out.ofs, buf, ofs, rest);
        out.ofs := out.ofs + rest;
        rest := 0
      END
    RETURN
      count - rest
    END Copy;
  RETURN
    Copy(out(ROut), buf, ofs, count)
  END Write;

  PROCEDURE WriteChars(VAR out: V.Base; buf: ARRAY OF CHAR; ofs, count: INTEGER)
                      : INTEGER;
    PROCEDURE Copy(VAR out: ROut; buf: ARRAY OF CHAR; ofs, count: INTEGER): INTEGER;
    VAR rest: INTEGER;
    BEGIN
      rest := count;
      IF rest > Size - out.ofs THEN
        IF out.ofs # Size THEN
          ArrayCopy.CharsToBytes(out.last.data, out.ofs, buf, ofs, Size - out.ofs);
          ofs := ofs + (Size - out.ofs);
          rest := rest - (Size - out.ofs)
        END;
        out.ofs := 0;
        WHILE AddBlock(out) & (rest >= Size) DO
          ArrayCopy.CharsToBytes(out.last.data, 0, buf, ofs, Size);
          INC(ofs, Size);
          DEC(rest, Size)
        END
      END;
      IF rest > 0 THEN
        ArrayCopy.CharsToBytes(out.last.data, out.ofs, buf, ofs, rest);
        out.ofs := out.ofs + rest;
        rest := 0
      END
    RETURN
      count - rest
    END Copy;
  RETURN
    Copy(out(ROut), buf, ofs, count)
  END WriteChars;

  PROCEDURE Init(VAR out: ROut): BOOLEAN;
  BEGIN
    NEW(out.first);
    IF out.first # NIL THEN
      out.first.next := NIL;
      Stream.InitOut(out, Write, WriteChars, NIL);
      out.last  := out.first;
      out.ofs   := 0
    END
  RETURN
    out.first # NIL
  END Init;

  PROCEDURE New*(VAR out: Out): BOOLEAN;
  BEGIN
    NEW(out);
    IF (out # NIL) & ~Init(out^) THEN
      out := NIL
    END
  RETURN
    out # NIL
  END New;

  PROCEDURE Pass*(out: Out; ctx: V.Base; handle: Handle): BOOLEAN;
  VAR b: Block; end: BOOLEAN;
  BEGIN
    b := out.first;
    WHILE (b # out.last) & handle(ctx, b.data, Size) DO
      b := b.next
    END;
    IF (b = out.last) & (out.ofs > 0) THEN
      IF out.ofs < Size THEN
        b.data[out.ofs] := 0
      END;
      end := handle(ctx, b.data, out.ofs)
    ELSE
      end := b = out.last
    END
  RETURN
    end
  END Pass;

  PROCEDURE InSetBlock(VAR in: RIn; b: Block);
  BEGIN
    in.block := b;
    in.ofs   := 0;
    IF b = NIL THEN
      in.end := 0
    ELSIF b.next = NIL THEN
      in.end := in.last
    ELSE
      in.end := Size
    END
  END InSetBlock;

  PROCEDURE IncOfs(VAR in: RIn; len: INTEGER);
  BEGIN
    in.ofs := in.ofs + len;
    IF in.ofs = Size THEN
      InSetBlock(in, in.block.next)
    END
  END IncOfs;

  PROCEDURE Read(VAR in: V.Base; VAR buf: ARRAY OF BYTE; ofs, count: INTEGER)
                : INTEGER;

    PROCEDURE Copy(VAR in: RIn; VAR buf: ARRAY OF BYTE; ofs, count: INTEGER): INTEGER;
    VAR rest, len: INTEGER;
    BEGIN
      rest := count;
      len := in.end - in.ofs;
      IF len > 0 THEN
        IF in.ofs > 0 THEN
          IF rest < len THEN
            len := rest
          END;
          ArrayCopy.Bytes(buf, ofs, in.block.data, in.ofs, len);
          IncOfs(in, len);
          ofs  := ofs + len;
          rest := rest - len
        ELSE
          ASSERT(in.ofs = 0)
        END;
        WHILE (rest >= Size) & (in.block.next # NIL) DO
          ArrayCopy.Bytes(buf, ofs, in.block.data, in.ofs, Size);
          in.block := in.block.next;
          INC(ofs, Size);
          DEC(rest, Size)
        END;
        IF in.block.next = NIL THEN
          in.end := in.last
        END;
        len := in.end - in.ofs;
        IF (len > 0) & (rest > 0) THEN
          IF rest < len THEN
            len := rest
          END;
          ArrayCopy.Bytes(buf, ofs, in.block.data, in.ofs, len);
          IncOfs(in, len);
          rest := rest - len
        END
      END
    RETURN
      count - rest
    END Copy;
  RETURN
    Copy(in(RIn), buf, ofs, count)
  END Read;

  PROCEDURE ReadChars(VAR in: V.Base; VAR buf: ARRAY OF CHAR; ofs, count: INTEGER)
                : INTEGER;
    PROCEDURE Copy(VAR in: RIn; VAR buf: ARRAY OF CHAR; ofs, count: INTEGER): INTEGER;
    VAR rest, len: INTEGER;
    BEGIN
      rest := count;
      len := in.end - in.ofs;
      IF len > 0 THEN
        IF in.ofs > 0 THEN
          IF rest < len THEN
            len := rest
          END;
          ArrayCopy.BytesToChars(buf, ofs, in.block.data, in.ofs, len);
          IncOfs(in, len);
          ofs  := ofs + len;
          rest := rest - len
        ELSE
          ASSERT(in.ofs = 0)
        END;
        WHILE (rest >= Size) & (in.block.next # NIL) DO
          ArrayCopy.BytesToChars(buf, ofs, in.block.data, in.ofs, Size);
          in.block := in.block.next;
          INC(ofs, Size);
          DEC(rest, Size)
        END;
        IF in.block.next = NIL THEN
          in.end := in.last
        END;
        len := in.end - in.ofs;
        IF (len > 0) & (rest > 0) THEN
          IF rest < len THEN
            len := rest
          END;
          ArrayCopy.BytesToChars(buf, ofs, in.block.data, in.ofs, len);
          IncOfs(in, len);
          rest := rest - len
        END
      END
    RETURN
      count - rest
    END Copy;
  RETURN
    Copy(in(RIn), buf, ofs, count)
  END ReadChars;

  PROCEDURE InitIn(VAR in: RIn; out: ROut);
  BEGIN
    Stream.InitIn(in, Read, ReadChars, NIL);
    in.last := out.ofs;
    InSetBlock(in, out.first)
  END InitIn;

  PROCEDURE NewIn*(VAR in: In; out: Out): BOOLEAN;
  BEGIN
    NEW(in);
    IF in # NIL THEN
      InitIn(in^, out^)
    END
  RETURN
    in # NIL
  END NewIn;

END VMemStream.
