module VM.build;

import VM.OpCode;
import VM.Binary;
import VM.Instruction;
import VM.Register;
import VM.Mode;

auto opcode(in Instruction instr)
{
    return opcode(instr, Mode.None);
}

auto opcode(in Instruction instr, in Mode mode)
{
    return opcode(instr, mode, 0);
}

auto opcode(in Instruction instr, in Mode mode, int value)
{
    return OpCode(instr).put(mode).put(Binary!int(value));
}

auto halt()
{
    return opcode(Instruction.Halt);
}

auto move(int value, in Register reg)
{
    return opcode(Instruction.Move, Mode.Immediate, value).put(reg);
}

auto move(in Register r1, in Register r2)
{
    return opcode(Instruction.Move, Mode.Register).put(r1, r2);
}

auto assign(int value)
{
    return opcode(Instruction.Assign, Mode.Immediate, value);
}

auto assign(in Register reg)
{
    return opcode(Instruction.Assign, Mode.Register).put(reg);
}

auto index(int value)
{
    return opcode(Instruction.Index, Mode.Immediate, value);
}

auto index(in Register reg)
{
    return opcode(Instruction.Index, Mode.Register).put(reg);
}

auto push(int value)
{
    return opcode(Instruction.Push, Mode.Immediate, value);
}

auto push(in Register reg)
{
    return opcode(Instruction.Push, Mode.Register).put(reg);
}

auto pop(in Register reg)
{
    return opcode(Instruction.Pop).put(reg);
}

auto add(in Register r1, in Register r2)
{
    return add(r1, r2, r1);
}

auto add(in Register r1, in Register r2, in Register r3)
{
    return opcode(Instruction.Add, Mode.None).put(r1, r2, r3);
}

auto print(in Register reg)
{
    return opcode(Instruction.Print, Mode.Register).put(reg);
}

auto print(in Mode mode, int value)
{
    return opcode(Instruction.Print, mode, value);
}

auto equal(in Register r1, in Register r2)
{
    return opcode(Instruction.Equal).put(r1, r2);
}

auto not(in Register reg)
{
    return opcode(Instruction.Not).put(reg);
}