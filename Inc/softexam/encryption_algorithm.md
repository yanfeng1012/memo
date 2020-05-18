# 加密算法

> 加密算法分 **<font color="red">`对称加密`</font>** 和 **<font color="red">`非对称加密`</font>**，其中对称加密算法的加密与解密 密钥相同，非对称加密算法的加密密钥与解密 密钥不同，此外，还有一类 不需要密钥 的 散列算法。

> 常见的 对称加密 算法主要有 **<font color="red">`DES`</font>**、**<font color="red">`3DES`</font>**、**<font color="red">`AES`</font>** 等，常见的 非对称算法 主要有 **<font color="red">`RSA`</font>**、**<font color="red">`DSA`</font>** 等，散列算法 主要有 **<font color="red">`SHA-1`</font>**、**<font color="red">`MD5`</font>** 等。

### MD5

>MD5 用的是 哈希函数，它的典型应用是对一段信息产生 **<font color="red">`信息摘要`</font>**，以 防止被篡改。严格来说，MD5 不是一种 加密算法 而是 **<font color="red">`摘要算法`</font>**。无论是多长的输入，MD5 都会输出长度为 128bits 的一个串 (通常用 16 进制 表示为 32 个字符)。

### SHA1算法

>SHA1 是和 MD5 一样流行的 **<font color="red">`消息摘要算法`</font>**，然而 SHA1 比 MD5 的 安全性更强。对于长度小于 2<sup>64</sup> 位的消息，SHA1 会产生一个  **<font color="red">`160 位的 消息摘要`</font>**。基于 MD5、SHA1 的信息摘要特性以及 不可逆 (一般而言)，可以被应用在检查 文件完整性 以及 **<font color="red">`数字签名`</font>** 等场景。

## AES/DES/3DES算法

>**<font color="red">`AES`</font>**、**<font color="red">`DES`</font>**、**<font color="red">`3DES`</font>** 都是 **<font color="red">`对称`</font>** 的 **<font color="red">`块加密算法`</font>**，加解密 的过程是 可逆的。常用的有 **<font color="red">`AES128`</font>**、**<font color="red">`AES192`</font>**、**<font color="red">`AES256`</font>**。

### DES算法

>**<font color="red">`DES`</font>** 加密算法是一种 **<font color="red">`分组密码`</font>**，以 64 位为 分组对数据 加密，它的 密钥长度 是 56 位，加密解密 用 同一算法。

>DES 加密算法是对 密钥 进行保密，而 公开算法，包括加密和解密算法。这样，只有掌握了和发送方 相同密钥 的人才能解读由 DES加密算法加密的密文数据。因此，破译 DES 加密算法实际上就是 搜索密钥的编码。对于 56 位长度的 密钥 来说，如果用 穷举法 来进行搜索的话，其运算次数为 2<sup>56</sup> 次。

### 3DES算法

>是 **<font color="red">`基于 DES`</font>** 的 对称算法，对 一块数据 用 **<font color="red">`三个不同的密钥`</font>** 进行 **<font color="red">`三次加密`</font>**，强度更高。

### AES算法

>**<font color="red">`AES`</font>** 加密算法是密码学中的 高级加密标准，该加密算法采用 对称分组密码体制，密钥长度的最少支持为 128 位、 192 位、256 位，分组长度 128 位，算法应易于各种硬件和软件实现。这种加密算法是美国联邦政府采用的 区块加密标准。

### RSA算法

>**<font color="red">`RSA`</font>** 加密算法是目前最有影响力的 **<font color="red">`公钥加密算法`</font>**，并且被普遍认为是目前 最优秀的公钥方案 之一。RSA 是第一个能同时用于 **<font color="red">`加密`</font>** 和 **<font color="red">`数字签名`</font>** 的算法，它能够 抵抗 到目前为止已知的 所有密码攻击，已被 ISO 推荐为公钥数据加密标准。

### ECC算法

>**<font color="red">`ECC`</font>** 也是一种 **<font color="red">`非对称加密算法`</font>**，主要优势是在某些情况下，它比其他的方法使用 **<font color="red">`更小的密钥`</font>**，比如 RSA 加密算法，提供 相当的或更高等级 的安全级别。不过一个缺点是 加密和解密操作 的实现比其他机制 时间长 (相比 RSA 算法，该算法对 CPU 消耗严重)。
