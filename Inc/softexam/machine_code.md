## 机器数编码

- 简介

>机器数有无符号数和带符号数之分。

>无符号数表示正数，在机器数中没有符号位。对于无符号数，若约定小数点的位置在机器数的最低位之后，则是纯整数;若约定小数点的位置在机器数的最高位之前，则是纯小数。

>对于带符号数，机器数的最高位是表示正、负的符号位，其余位则表示数值。若约定小数点的位置在机器数的最低数值位之后，则是纯整数;若约定小数点的位置在机器数的最高数值位之前(符号位之后)，则是纯小数。

- 码制

>为了便于运算，带符号的机器数可采用原码、反码、补码和移码等不同的编码方法，机器数的这些编码方法称为码制。

>正数的原码、反码、补码完全相同，其符号位为0，其余位取值不变。

>对于负数，负数的原码其符号位为1,其余各位取值不变;负数的反码其符号位为1,其余各位在原码基础上按位取反;负数的补码其符号位为1,其余各位在原码的基础上按位求反，再在末位上加1。

- 运算

>对于原码加减，操作数与运算结果均用原码表示。

>当两个相同符号的原码数相加时，只需将数值部分直接相加，运算结果的符号与两个加数的符号相同。

>若两个加数的符号相异，则应进行减法运算，其方法是先比较两个数绝对值的大小，然后用绝对值大者的绝对
值减去绝对值小者的绝对值，结果的符号取绝对值大者的符号。由于原码加减运算时符号位要单独处理，使得运算较复杂，因此在计算机中很少被采用。

>为了简化运算方法，常采用**补码**表示法，以便符号位也能作为数值的一部分参与运算。

>补码加法的运算法则是和的补码等于补码求和。

>补码减法的运算法则是差的补码等于被减数的补码加上减数取负后的补码。

>负数补码表示的实质是将负数映射到正数域，所以可将减法运算化为加法运算，这也是引入补码的原因。

>与原码减运算相比，补码减运算的过程要简便得多。

>在补码加减运算中，符号位和数值位一样参加运算，无须作特殊处理。

>因此，多数计算机都采用补码加减运算法。

>移码是机器数的又一种表示方法，又称增码，多表示浮点数的阶码。移码的符号位，用1表示正号，用0表示负号，其求法是把其补码的符号位直接变反即可。

