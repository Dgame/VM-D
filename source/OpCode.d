module VM.OpCode;

import VM.Binary;
import VM.Instruction;
import VM.Register;
import VM.Mode;

struct OpCode
{
    enum size = 56;

    ubyte[size] bits;
    ubyte offset = 0;

    this(in Instruction instr)
    {
        this.put(Binary!ubyte(instr));
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
        return cast(Mode) decode(this.bits[8 .. 12]);
    }

    auto value() const
    {
        return Binary!int(this.bits[12 .. 44]).value;
    }

    auto register() const
    {
        import VM.util: s;
        
        return [
            cast(Register) decode(this.bits[44 .. 48]),
            cast(Register) decode(this.bits[48 .. 52]),
            cast(Register) decode(this.bits[52 .. 56])
        ].s;
    }

    ref OpCode emplace(int value, ubyte size)
    {
        this.bits[this.offset .. this.offset + size] = Binary!int(value).bits[$ - size .. $];
        this.offset += size;

        return this;
    }

    ref OpCode put(T)(in Binary!T bin)
    {
        bits[this.offset .. this.offset + bin.size] = bin.bits;
        this.offset += bin.size;

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
        return this.emplace(r1, 4).emplace(r2, 4).emplace(r3, 4);
    }

    ref OpCode put(in Mode mode)
    {
        return this.emplace(mode, 4);
    }
}
