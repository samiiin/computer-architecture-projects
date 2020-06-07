library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pcsrc           : in     vl_logic;
        pccond          : in     vl_logic;
        pcwrite         : in     vl_logic;
        memread         : in     vl_logic;
        memwrite        : in     vl_logic;
        irwrite         : in     vl_logic;
        iord            : in     vl_logic;
        stacksrc        : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        tos             : in     vl_logic;
        lda             : in     vl_logic;
        ldb             : in     vl_logic;
        srca            : in     vl_logic;
        srcb            : in     vl_logic;
        aluop           : in     vl_logic_vector(1 downto 0);
        opcode          : out    vl_logic_vector(2 downto 0)
    );
end datapath;
