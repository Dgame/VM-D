import std.stdio: writeln;
import VM.build;
import VM.Interpreter;
import VM.Binary;
import VM.Instruction;
import VM.Register;
import VM.interpret;

void main()
{
    // auto b1 = Binary!byte(42);

    // writeln(b1.bits);
    // writeln(b1.value);

    // auto b2 = Binary!short(2500);

    // writeln(b2.bits);
    // writeln(b2.value);

    // auto b3 = Binary!int(70000);

    // writeln(b3.bits);
    // writeln(b3.value);

    // writeln(Binary!byte.size);

    // auto opc = loadi(42, Register.AX);
    // writeln(opc.instruction);
    // writeln(opc.mode);
    // writeln(opc.value);
    // writeln(opc.register);

    Interpreter vm;
    vm.append(Instruction.Halt, &halt);
    vm.append(Instruction.Move, &move);
    vm.append(Instruction.Assign, &assign);
    vm.append(Instruction.Index, &index);
    vm.append(Instruction.Push, &push);
    vm.append(Instruction.Pop, &pop);
    vm.append(Instruction.Print, &print);
    vm.append(Instruction.Add, &add);
    vm.append(Instruction.Sub, &sub);
    vm.append(Instruction.Mul, &mul);
    vm.append(Instruction.Div, &div);
    vm.append(Instruction.Equal, &equal);
    vm.append(Instruction.Smaller, &smaller);
    vm.append(Instruction.SmallerEqual, &smallerEqual);
    vm.append(Instruction.Not, &not);

    vm.append(move(42, Register.AX));
    vm.append(move(23, Register.BX));
    vm.append(add(Register.AX, Register.BX));
    vm.append(print(Register.AX));
    vm.append(print(Register.AX));
    vm.append(equal(Register.AX, Register.BX));
    vm.append(print(Register.ZX));
    vm.append(not(Register.ZX));
    vm.append(print(Register.ZX));
    vm.append(halt());
    vm.run();
}