module VM.OpCode;

import std.stdio: writeln;
import VM.Binary;
import VM.Instruction;
import VM.Register;
import VM.Mode;
import VM.Type;

struct OpCode
{
    enum size = 58;

    ubyte[size] bits;
    ubyte offset = 0;

    this(in Instruction instr)
    {
        this.put(instr);
    }

    this(ubyte[size] bits)
    {
        this.bits = bits;
    }

    this(in ubyte[] bits)
    {
        this(bits[0 .. size]);
    }

    auto instruction() const
    {
        return cast(Instruction) Binary!ubyte(this.bits[0 .. 8]).value;
    }

    auto mode() const
    {
        return cast(Mode) decode(this.bits[8 .. 10]);
    }

    auto type() const
    {
        return cast(Type) decode(this.bits[10 .. 14]);
    }

    auto value() const
    {
        return Binary!int(this.bits[14 .. 46]).value;
    }

    auto register() const
    {
        import VM.util: s;
        
        return [
            cast(Register) decode(this.bits[46 .. 50]),
            cast(Register) decode(this.bits[50 .. 54]),
            cast(Register) decode(this.bits[54 .. 58])
        ].s;
    }

    ref OpCode put(in Instruction instr)
    {
        this.bits[0 .. 8] = Binary!ubyte(instr).bits;

        return this;
    }

    ref OpCode put(in Mode mode)
    {
        this.bits[8 .. 10] = Binary!ubyte(mode).bits[6 .. 8];

        return this;
    }

    ref OpCode put(in Type type)
    {
        this.bits[10 .. 14] = Binary!ubyte(type).bits[4 .. 8];

        return this;
    }

    ref OpCode put(int value)
    {
        this.bits[14 .. 46] = Binary!int(value).bits;

        return this;
    }

    ref OpCode put(in Register reg)
    {
        return this.put(reg, Register.None, Register.None);
    }

    ref OpCode put(in Register r1, in Register r2)
    {
        return this.put(r1, r2, Register.None);
    }

    ref OpCode put(in Register r1, in Register r2, in Register r3)
    {
        this.bits[46 .. 50] = Binary!ubyte(r1).bits[4 .. 8];
        this.bits[50 .. 54] = Binary!ubyte(r2).bits[4 .. 8];
        this.bits[54 .. 58] = Binary!ubyte(r3).bits[4 .. 8];

        return this;
    }
}
