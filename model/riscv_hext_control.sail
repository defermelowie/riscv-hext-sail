/*=======================================================================================*/
/*  This Sail RISC-V architecture model, comprising all files and                        */
/*  directories except where otherwise noted is subject the BSD                          */
/*  two-clause license in the LICENSE file.                                              */
/*                                                                                       */
/*  SPDX-License-Identifier: BSD-2-Clause                                                */
/*=======================================================================================*/

function clause ext_is_CSR_defined(0x34A, _) = haveHExt() // mtinst
function clause ext_is_CSR_defined(0x34B, _) = haveHExt() // mtval2
function clause ext_is_CSR_defined(0x600, _) = haveHExt() // hstatus
function clause ext_is_CSR_defined(0x602, _) = haveHExt() // hedeleg
function clause ext_is_CSR_defined(0x603, _) = haveHExt() // hideleg
function clause ext_is_CSR_defined(0x604, _) = haveHExt() // hie
function clause ext_is_CSR_defined(0x606, _) = haveHExt() // hcounteren
function clause ext_is_CSR_defined(0x607, _) = haveHExt() // hgeie
function clause ext_is_CSR_defined(0x643, _) = haveHExt() // htval
function clause ext_is_CSR_defined(0x644, _) = haveHExt() // hip
function clause ext_is_CSR_defined(0x645, _) = haveHExt() // hvip
function clause ext_is_CSR_defined(0x64A, _) = haveHExt() // htinst
function clause ext_is_CSR_defined(0xE12, _) = haveHExt() // hgeip
function clause ext_is_CSR_defined(0x60A, _) = haveHExt() // henvcfg
function clause ext_is_CSR_defined(0x61A, _) = haveHExt() // henvcfgh
function clause ext_is_CSR_defined(0x680, _) = haveHExt() // hgatp
function clause ext_is_CSR_defined(0x605, _) = haveHExt() // htimedelta
function clause ext_is_CSR_defined(0x615, _) = haveHExt() // htimedeltah
function clause ext_is_CSR_defined(0x200, _) = haveHExt() // vsstatus
function clause ext_is_CSR_defined(0x204, _) = haveHExt() // vsie
function clause ext_is_CSR_defined(0x205, _) = haveHExt() // vstvec
function clause ext_is_CSR_defined(0x240, _) = haveHExt() // vsscratch
function clause ext_is_CSR_defined(0x241, _) = haveHExt() // vsepc
function clause ext_is_CSR_defined(0x242, _) = haveHExt() // vscause
function clause ext_is_CSR_defined(0x243, _) = haveHExt() // vstval
function clause ext_is_CSR_defined(0x244, _) = haveHExt() // vsip
function clause ext_is_CSR_defined(0x280, _) = haveHExt() // vsatp

function clause ext_read_CSR(0x34A) = Some(mtinst)
function clause ext_read_CSR(0x34B) = Some(mtval2)
function clause ext_read_CSR(0x600) = Some(hstatus.bits)
function clause ext_read_CSR(0x602) = Some(hedeleg.bits)
function clause ext_read_CSR(0x603) = Some(hideleg.bits)
function clause ext_read_CSR(0x604) = Some(lower_mie_to_hie(mie).bits)
function clause ext_read_CSR(0x606) = Some(zero_extend(hcounteren.bits))
function clause ext_read_CSR(0x607) = Some(hgeie)
function clause ext_read_CSR(0x643) = Some(htval)
function clause ext_read_CSR(0x644) = Some(lower_mip_to_hip(mip).bits)
function clause ext_read_CSR(0x645) = Some(lower_mip_to_hvip(mip).bits)
function clause ext_read_CSR(0x64A) = Some(htinst)
function clause ext_read_CSR(0xE12) = Some(hgeip)
function clause ext_read_CSR(0x60A) = Some(henvcfg.bits[sizeof(xlen) - 1 .. 0])
function clause ext_read_CSR(0x61A) = if sizeof(xlen) == 32 then Some(henvcfg.bits[63 .. 32]) else None()
// function clause ext_read_CSR(0x680) = Some(hgatp) // TODO: Second Level Address Translation
function clause ext_read_CSR(0x605) = Some(htimedelta[sizeof(xlen) - 1 .. 0])
function clause ext_read_CSR(0x615) = if sizeof(xlen) == 32 then Some(htimedelta[63 .. 32]) else None()
function clause ext_read_CSR(0x200) = Some(vsstatus.bits[sizeof(xlen) - 1 .. 0])
function clause ext_read_CSR(0x204) = Some(lower_mie_to_vsie(mie, hideleg).bits)
function clause ext_read_CSR(0x205) = Some(vstvec.bits)
function clause ext_read_CSR(0x240) = Some(vsscratch)
function clause ext_read_CSR(0x241) = Some(vsepc)
function clause ext_read_CSR(0x242) = Some(vscause.bits)
function clause ext_read_CSR(0x243) = Some(vstval)
function clause ext_read_CSR(0x244) = Some(lower_mip_to_vsip(mip, hideleg).bits)
function clause ext_read_CSR(0x280) = Some(vsatp)

function clause ext_write_CSR(0x34A, value) = { mtinst = value; Some(mtinst) }
function clause ext_write_CSR(0x34B, value) = { mtval2 = value; Some(mtval2) }
function clause ext_write_CSR(0x600, value) = { hstatus = legalize_hstatus(hstatus, value); Some(hstatus.bits) }
function clause ext_write_CSR(0x602, value) = { hedeleg = legalize_hedeleg(hedeleg, value); Some(hedeleg.bits) }
function clause ext_write_CSR(0x603, value) = { hideleg = legalize_hideleg(hideleg, value); Some(hideleg.bits) }
function clause ext_write_CSR(0x604, value) = { mie = legalize_hie(mie, value); Some(lower_mie_to_hie(mie).bits) }
function clause ext_write_CSR(0x606, value) = { hcounteren = legalize_hcounteren(hcounteren, value); Some(zero_extend(hcounteren.bits)) }
function clause ext_write_CSR(0x607, value) = { hgeie = legalize_hgeie(value); Some(hgeie) }
function clause ext_write_CSR(0x60A, value) = { henvcfg = if sizeof(xlen) == 32
                                                          then legalize_henvcfg(henvcfg, henvcfg.bits[63 .. 32] @ value)
                                                          else legalize_henvcfg(henvcfg, value);
                                                Some(henvcfg.bits[(sizeof(xlen) - 1) .. 0])
                                              }
function clause ext_write_CSR(0x61A, value) = { if sizeof(xlen) == 32
                                                then {
                                                  henvcfg = legalize_henvcfg(henvcfg, value @ henvcfg.bits[31 .. 0]);
                                                  Some(henvcfg.bits[63 .. 32])
                                                } else None()
                                              }
function clause ext_write_CSR(0x643, value) = { htval = value; Some(htval) }
function clause ext_write_CSR(0x644, value) = { mip = legalize_hip(mip, value); Some(lower_mip_to_hip(mip).bits) }
function clause ext_write_CSR(0x645, value) = { mip = legalize_hvip(mip, value); Some(lower_mip_to_hvip(mip).bits) }
function clause ext_write_CSR(0x64A, value) = { htinst = value; Some(htinst) }
function clause ext_write_CSR(0xE12,     _) = None() // hgeip is read-only
// function clause ext_write_CSR(0x680, value) = { hgatp = legalize_hgatp(cur_Architecture(), hgatp, value); Some(hgatp) } // TODO: Second Level Address Translation
function clause ext_write_CSR(0x605, value) = { htimedelta[(sizeof(xlen) - 1) .. 0] = value; Some(htimedelta[(sizeof(xlen) - 1) .. 0])}
function clause ext_write_CSR(0x615, value) = { if sizeof(xlen) == 32
                                                then {
                                                  htimedelta[63 .. 32] = value;
                                                  Some(htimedelta[63 .. 32])
                                                } else None()
                                              }
function clause ext_write_CSR(0x200, value) = { vsstatus = legalize_vsstatus(vsstatus, value); Some(vsstatus.bits[(sizeof(xlen) - 1) .. 0]) }
function clause ext_write_CSR(0x204, value) = { mie = legalize_vsie(mie, hideleg, value); Some(lower_mie_to_vsie(mie, hideleg).bits) }
function clause ext_write_CSR(0x205, value) = { vstvec = Mk_Mtvec(value); Some(vstvec.bits) }
function clause ext_write_CSR(0x240, value) = { vsscratch = value; Some(vsscratch) }
function clause ext_write_CSR(0x241, value) = { vsepc = value; Some(vsepc) }
function clause ext_write_CSR(0x242, value) = { vscause = Mk_Mcause(value); Some(vscause.bits) }
function clause ext_write_CSR(0x243, value) = { vstval = value; Some(vstval) }
function clause ext_write_CSR(0x244, value) = { mip = legalize_vsip(mip, hideleg, value); Some(lower_mip_to_vsip(mip, hideleg).bits) }
function clause ext_write_CSR(0x280, value) = { vsatp = value; Some(vsatp) }

/*! Initialize hypervisor extension */
function init_hext() -> unit = {
  /* Start with V=0 */

  cur_virtualization = V0;

  /* Init H-extension specific fields of M-mode CRSs */

  mstatus[MPV] = virtMode_to_bits(cur_virtualization);
  mstatus[GVA] = 0b0;

  mtinst = zeros();
  mtval2 = zeros();

  mideleg = [mideleg with VSEI = 0b1, VSTI = 0b1, VSSI = 0b1];
  mideleg = [mideleg with SGEI = 0b1]; /* Note: SGEI is "read-only one" only if GEILEN > 0 */

  /* Init H-extension specific HS-mode CSRs */

  hstatus = Mk_Hstatus(zeros());
  hstatus = set_hstatus_VSXL(hstatus, misa[MXL]); /* Dynamic XLEN changes are not (yet) supported */

  hedeleg = Mk_Medeleg(zeros());
  hideleg = Mk_Minterrupts(zeros());
  hcounteren = Mk_Counteren(zeros());
  htval = zeros();
  htval = zeros();
  hgeie = legalize_hgeie(zeros());
  hgeip = zeros();
  henvcfg = Mk_HEnvcfg(zeros());
  htimedelta = zeros();

  /* Init VS-mode CSRs */

  vsstatus = Mk_Sstatus(zeros());
  vsstatus = set_sstatus_UXL(vsstatus, misa[MXL]); /* Dynamic XLEN changes are not (yet) supported */

  vstvec = Mk_Mtvec(zeros());
  vsscratch = zeros();
  vsepc = zeros();
  vscause = Mk_Mcause(zeros());
  vstval = zeros();
  vsatp = zeros();
}
