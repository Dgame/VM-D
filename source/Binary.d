module VM.Binary;

struct Binary(T)
{
    enum size = T.sizeof * 8;
    immutable ubyte[size] bits;

    this(T value)
    {
        this.bits = encode(value);
    }

    this(ubyte[size] bits)
    {
        this.bits = bits;
    }

    this(in ubyte[] bits)
    {
        this(bits[0 .. size]);
    }

    auto value() const
    {
        return decode(this.bits);
    }
    
    static auto encode(T)(T value)
    {
        ubyte[size] bits;
        size_t len = size;
        while (value) {
            len--;
            bits[len] = (value & 1) ? 1 : 0;
            value >>= 1;
        }

        return bits;
    }

    static auto decode(ubyte[size] bits)
    {
        return .decode(bits[]);
    }
}

auto decode(in ubyte[] bits)
{
    int result;
    for (int i = bits.length - 1, j = 0; i >= 0; i--, j++) {
        result += bits[i] ? (1 << j) : 0;
    }

    return result;
}