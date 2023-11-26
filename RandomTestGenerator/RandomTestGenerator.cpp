for(int i=0; i<100; i++)
{
    int random = rand() % 10;
    opcode = randomOPCODE[random];
    U_IMM = toBinary(rand() % 1048576,20);
    I_IMM = toBinary(rand() % 4096,12);
    B_IMM = toBinary(rand() % 4096,12);
    S_IMM = toBinary(rand() % 4096,12);
    Rd = toBinary(rand() % 32,5);
    rs1 = toBinary(rand() % 32,5);
    rs2 = toBinary(rand() % 32,5);
    shamt = toBinary(rand() % 32,5);

    if(opcode == "0110111")//LUI
    {
        FinalOutput = U_IMM + Rd + opcode;
    }
    else if(opcode == "0010111") //AUIPC
    {
        FinalOutput = U_IMM + Rd + opcode;
    }
    else if(opcode == "1101111")//Jal
    {
        FinalOutput =  U_IMM + Rd + opcode;
    }
    else if(opcode == "1100111")//JALR
    {
        FinalOutput = I_IMM + rs1 + "000" + Rd + opcode;
    }
    else if(opcode == "1100011") //branch
    {
        
        FinalOutput = B_IMM.substr(B_IMM.length()-7,B_IMM.length()) + rs2 + rs1 + randomFUNCT3B[rand()%6] +B_IMM.substr(0,5)+ opcode;
    }
    else if(opcode == "0000011")//LW
    {
        FinalOutput = I_IMM + rs1 + randomFUNCT3L[rand()%5] + Rd +opcode;
    }
    else if(opcode == "0100011")
    {
        FinalOutput = S_IMM.substr(0,7) + rs2 + rs1 + randomFUNCT3S[rand()%3] + S_IMM.substr(7,5) + opcode;
    }
    else if(opcode == "0010011")//IType
    {
        string funct3 = randomFUNCT3I[rand()%6];

        if(funct3 == "001" || "101")
        {
            if(funct3 == "101")
            {
            
                if((rand()%2) == 0)
                {
                    FinalOutput = "0000000"+shamt + rs1 + "101" + Rd + opcode;
                }
                else
                {
                    FinalOutput = "0100000"+ shamt + rs1 + "101" + Rd + opcode;
                }
            }
            else
            {
                   FinalOutput = "0000000"+shamt + rs1 + "011" + Rd + opcode;

            }
        }
        else
        {
            FinalOutput = FinalOutput = I_IMM + rs1 + funct3 + Rd + opcode;

        }
    }
    else if(opcode == "0110011")
    {
        string funct3 = randomFUNCT3R[rand()%8];

        if(funct3 == "000")
        {
            if((rand()%2) == 0)
            {
                FinalOutput = "0000000"+rs2 + rs1 + "000" + Rd + opcode;
            }
            else
            {
                FinalOutput = "0100000"+ rs2 + rs1 + "000" + Rd + opcode;
            }
        }
        if(funct3 == "101")
        {
            if((rand()%2) == 0)
            {
                FinalOutput = "0000000"+rs2 + rs1 + "000" + Rd + opcode;
            }
            else
            {
                FinalOutput = "0100000"+ rs2 + rs1 + "000" + Rd + opcode;
            }
        }
        else
        {
            FinalOutput = "0000000" + rs2 + rs1 + funct3 + Rd + opcode;
        }
    }
    else if(opcode == "0001111")
    {
        FinalOutput = I_IMM + rs1 + "000" + Rd + opcode;
    }
    else if(opcode == "1110011")
    {
        if(rand()%2 == 0)
        {
            FinalOutput = "00000000000000000000000001110011";
        }
        else
        {
            FinalOutput = "00000000000100000000000001110011";
        }
    }
    else    {
        cout << opcode << "Error" << endl;
    }
    if(FinalOutput.length() != 32)
    {
        continue;
    }
    else
    {
        cout << FinalOutput << endl;
    }
}   
}