library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        opcode          : in     vl_logic_vector(2 downto 0);
        pcsrc           : out    vl_logic;
        pccond          : out    vl_logic;
        iord            : out    vl_logic;
        pcwrite         : out    vl_logic;
        memread         : out    vl_logic;
        memwrite        : out    vl_logic;
        irwrite         : out    vl_logic;
        stacksrc        : out    vl_logic;
        push            : out    vl_logic;
        pop             : out    vl_logic;
        tos             : out    vl_logic;
        lda             : out    vl_logic;
        ldb             : out    vl_logic;
        srca            : out    vl_logic;
        srcb            : out    vl_logic;
        aluop           : out    vl_logic_vector(1 downto 0)
    );
end controller;
