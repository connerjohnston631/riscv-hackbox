// See LICENSE for license details.

package rocket

import Chisel._
import uncore._
import Util._

case object RoCCMaxTaggedMemXacts extends Field[Int]

class RoCCInstruction extends Bundle
{
  val funct = Bits(width = 7)
  val rs2 = Bits(width = 5)
  val rs1 = Bits(width = 5)
  val xd = Bool()
  val xs1 = Bool()
  val xs2 = Bool()
  val rd = Bits(width = 5)
  val opcode = Bits(width = 7)
}

class RoCCCommand extends CoreBundle
{
  val inst = new RoCCInstruction
  val rs1 = Bits(width = xLen)
  val rs2 = Bits(width = xLen)
}

class RoCCResponse extends CoreBundle
{
  val rd = Bits(width = 5)
  val data = Bits(width = xLen)
}

class RoCCInterface extends Bundle
{
  val cmd = Decoupled(new RoCCCommand).flip
  val resp = Decoupled(new RoCCResponse)
  val mem = new HellaCacheIO
  val busy = Bool(OUTPUT)
  val s = Bool(INPUT)
  val interrupt = Bool(OUTPUT)
  
  // These should be handled differently, eventually
  val imem = new ClientUncachedTileLinkIO
  val dmem = new ClientUncachedTileLinkIO
  val iptw = new TLBPTWIO
  val dptw = new TLBPTWIO
  val pptw = new TLBPTWIO
  val exception = Bool(INPUT)
}

abstract class RoCC extends CoreModule
{
  val io = new RoCCInterface
  io.mem.req.bits.phys := Bool(true) // don't perform address translation
}

class HackBoxIO extends Bundle{
  //example: val in_0 = UInt(INPUT, width = 64)
  val in_0 = UInt(INPUT, width = 64)
  val in_1 = UInt(INPUT, width = 64)
  val in_2 = UInt(INPUT, width = 64)


  val out = UInt(OUTPUT, width = 64)
}

class HackBox extends BlackBox{
  val io = new HackBoxIO()
}

class HackBoxAccumulator extends RoCC
{
  val n = 3
  val regfile = Mem(UInt(width = xLen), n)
  val busy = Vec.fill(n){Reg(init=Bool(false))}
  val cmd = Queue(io.cmd)
  val funct = cmd.bits.inst.funct
  val addr = cmd.bits.inst.rs2(log2Up(n)-1,0)
  val doWrite = funct === UInt(0)
  val doRead = funct === UInt(1)
  val doLoad = funct === UInt(2)
  val doAccum = funct === UInt(3)
  val memRespTag = io.mem.resp.bits.tag(log2Up(n)-1,0)

  // datapath
  val addend = cmd.bits.rs1

  //track all values coming from the regfile
  //example: val accum_0 = regfile(0)
  //...
  val accum_0= regfile(0)
  val accum_1= regfile(1)
  val accum_2= regfile(2)



  //black box declaration and input connection
  val hackBox = Module(new HackBox())
  //example: hackBox.io.in_0 := accum_0
  hackBox.io.in_0 := accum_0
  hackBox.io.in_1 := accum_1
  hackBox.io.in_2 := accum_2


 
  val wdata = Mux(doWrite, addend, hackBox.io.out) //<-- black box output

  when (cmd.fire() && (doWrite || doAccum)) {
    regfile(addr) := wdata
  }

  when (io.mem.resp.valid) {
    regfile(memRespTag) := io.mem.resp.bits.data
  }

  // control
  when (io.mem.req.fire()) {
    busy(addr) := Bool(true)
  }

  when (io.mem.resp.valid) {
    busy(memRespTag) := Bool(false)
  }

  val doResp = cmd.bits.inst.xd
  val stallReg = busy(addr)
  val stallLoad = doLoad && !io.mem.req.ready
  val stallResp = doResp && !io.resp.ready

  cmd.ready := !stallReg && !stallLoad && !stallResp
    // command resolved if no stalls AND not issuing a load that will need a request

  // PROC RESPONSE INTERFACE
  io.resp.valid := cmd.valid && doResp && !stallReg && !stallLoad
    // valid response if valid command, need a response, and no stalls
  io.resp.bits.rd := cmd.bits.inst.rd
    // Must respond with the appropriate tag or undefined behavior
  io.resp.bits.data := regfile(addr)
    // Semantics is to always send out prior accumulator register value

  io.busy := cmd.valid || busy.reduce(_||_)
    // Be busy when have pending memory requests or committed possibility of pending requests
  io.interrupt := Bool(false)
    // Set this true to trigger an interrupt on the processor (please refer to supervisor documentation)

  // MEMORY REQUEST INTERFACE
  io.mem.req.valid := cmd.valid && doLoad && !stallReg && !stallResp
  io.mem.req.bits.addr := addend
  io.mem.req.bits.tag := addr
  io.mem.req.bits.cmd := M_XRD // perform a load (M_XWR for stores)
  io.mem.req.bits.typ := MT_D // D = 8 bytes, W = 4, H = 2, B = 1
  io.mem.req.bits.data := Bits(0) // we're not performing any stores...
  io.mem.invalidate_lr := false

  io.imem.acquire.valid := false
  io.imem.grant.ready := false
  io.dmem.acquire.valid := false
  io.dmem.grant.ready := false
  io.iptw.req.valid := false
  io.dptw.req.valid := false
  io.pptw.req.valid := false
}
