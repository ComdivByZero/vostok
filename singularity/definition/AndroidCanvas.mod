(* Copyright 2018,2021 ComdivByZero
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
MODULE AndroidCanvas;

  IMPORT
    Paint := AndroidPaint, GPath := AndroidGraphPath;

  TYPE
    T* = POINTER TO RECORD END;

  PROCEDURE Line*(cnv: T; startX, startY, stopX, stopY: REAL; paint: Paint.T);
  BEGIN
    ASSERT(FALSE)
  END Line;

  PROCEDURE Rect*(cnv: T; left, top, right, bottom: REAL; paint: Paint.T);
  BEGIN
    ASSERT(FALSE)
  END Rect;

  PROCEDURE Path*(cnv: T; path: GPath.T; paint: Paint.T);
  BEGIN
    ASSERT(FALSE)
  END Path;

  PROCEDURE Text*(cnv: T; text: ARRAY OF CHAR; ofs: INTEGER; x, y: REAL; paint: Paint.T);
  BEGIN
    ASSERT((0 <= ofs) & (ofs < LEN(text)));
    ASSERT(FALSE)
  END Text;

  PROCEDURE Width*(cnv: T): INTEGER;
  BEGIN
    ASSERT(FALSE)
  RETURN
    0
  END Width;

  PROCEDURE Height*(cnv: T): INTEGER;
  BEGIN
    ASSERT(FALSE)
  RETURN
    0
  END Height;

  PROCEDURE Density*(cnv: T): INTEGER;
  BEGIN
    ASSERT(FALSE)
  RETURN
    0
  END Density;

  PROCEDURE SetDensity*(cnv: T; density: INTEGER);
  BEGIN
    ASSERT(FALSE)
  END SetDensity;

END AndroidCanvas.
