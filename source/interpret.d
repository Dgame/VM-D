module VM.interpret;

import std.stdio: writeln;
import VM.OpCode;
import VM.Interpreter;
import VM.Register;
import VM.Mode;

void halt(ref const OpCode opcode, ref Interpreter vm)
{
    writeln("halt");
    vm.stop();
}

void move(ref const OpCode opcode, ref Interpreter vm)
{
    if (opcode.mode == Mode.Immediate) {
        vm.setRegister(opcode.register[0], opcode.value);
    } else {
        vm.setRegister(opcode.register[0], opcode.register[1]);
    }
}

void assign(ref const OpCode opcode, ref Interpreter vm)
{
    if (opcode.mode == Mode.Immediate) {
        vm.setVariable(vm.index, opcode.value);
    } else {
        vm.setVariable(vm.index, opcode.register[0]);
    }
}

void index(ref const OpCode opcode, ref Interpreter vm)
{
    if (opcode.mode == Mode.Immediate) {
        vm.setIndex(opcode.value);
    } else {
        vm.setIndex(opcode.register[0]);
    }
}

void push(ref const OpCode opcode, ref Interpreter vm)
{
    if (opcode.mode == Mode.Immediate) {
        vm.push(opcode.value);
    } else {
        vm.push(opcode.register[0]);
    }
}

void pop(ref const OpCode opcode, ref Interpreter vm)
{
    vm.pop(opcode.register[0]);
}

void add(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];
    immutable r3 = opcode.register[2];

    vm.setRegister(r3, vm.getRegister(r1) + vm.getRegister(r2));
}

void sub(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];
    immutable r3 = opcode.register[2];

    vm.setRegister(r3, vm.getRegister(r1) - vm.getRegister(r2));
}

void mul(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];
    immutable r3 = opcode.register[2];

    vm.setRegister(r3, vm.getRegister(r1) * vm.getRegister(r2));
}

void div(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];
    immutable r3 = opcode.register[2];

    vm.setRegister(r3, vm.getRegister(r1) / vm.getRegister(r2));
}

void equal(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];

    vm.setRegister(Register.ZX, vm.getRegister(r1) == vm.getRegister(r2));
}

void smaller(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];

    vm.setRegister(Register.ZX, vm.getRegister(r1) < vm.getRegister(r2));
}

void smallerEqual(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];
    immutable r2 = opcode.register[1];

    vm.setRegister(Register.ZX, vm.getRegister(r1) <= vm.getRegister(r2));
}

void not(ref const OpCode opcode, ref Interpreter vm)
{
    immutable r1 = opcode.register[0];

    vm.setRegister(r1, !vm.getRegister(r1));
}

void print(ref const OpCode opcode, ref Interpreter vm)
{
    writeln("print: ", opcode.mode);
    switch (opcode.mode) {
        case Mode.Immediate:
            writeln(opcode.value);
            break;
        case Mode.Register:
            writeln(vm.getRegister(opcode.register[0]));
            break;
        default:
            break;
    }
}