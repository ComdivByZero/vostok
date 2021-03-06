/* Copyright 2016,2020 ComdivByZero
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
 */

#if !defined HEADER_GUARD_OsExec
#    define  HEADER_GUARD_OsExec 1

#define OsExec_Ok_cnst 0

extern o7_int_t OsExec_Do(O7_FPA(o7_char const, cmd));

O7_ALWAYS_INLINE void OsExec_init(void) { ; }
O7_ALWAYS_INLINE void OsExec_done(void) { ; }
#endif
