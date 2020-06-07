library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        memread         : in     vl_logic;
        memwrite        : in     vl_logic;
        clk             : in     vl_logic;
        address         : in     vl_logic_vector(4 downto 0);
        data            : in     vl_logic_vector(7 downto 0);
        memory_out      : out    vl_logic_vector(7 downto 0)
    );
end memory;
