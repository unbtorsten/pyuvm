// Generated by PeakRDL-regblock - A free and open-source SystemVerilog generator
//  https://github.com/SystemRDL/PeakRDL-regblock

module TinyALUreg (
        input wire clk,
        input wire rst,

        input wire s_apb_psel,
        input wire s_apb_penable,
        input wire s_apb_pwrite,
        input wire [2:0] s_apb_paddr,
        input wire [15:0] s_apb_pwdata,
        output logic s_apb_pready,
        output logic [15:0] s_apb_prdata,
        output logic s_apb_pslverr,

        input TinyALUreg_pkg::TinyALUreg__in_t hwif_in,
        output TinyALUreg_pkg::TinyALUreg__out_t hwif_out
    );

    //--------------------------------------------------------------------------
    // CPU Bus interface logic
    //--------------------------------------------------------------------------
    logic cpuif_req;
    logic cpuif_req_is_wr;
    logic [2:0] cpuif_addr;
    logic [15:0] cpuif_wr_data;
    logic [15:0] cpuif_wr_biten;
    logic cpuif_req_stall_wr;
    logic cpuif_req_stall_rd;

    logic cpuif_rd_ack;
    logic cpuif_rd_err;
    logic [15:0] cpuif_rd_data;

    logic cpuif_wr_ack;
    logic cpuif_wr_err;

    // Request
    logic is_active;
    always_ff @(posedge clk) begin
        if(rst) begin
            is_active <= '0;
            cpuif_req <= '0;
            cpuif_req_is_wr <= '0;
            cpuif_addr <= '0;
            cpuif_wr_data <= '0;
        end else begin
            if(~is_active) begin
                if(s_apb_psel) begin
                    is_active <= '1;
                    cpuif_req <= '1;
                    cpuif_req_is_wr <= s_apb_pwrite;
                    cpuif_addr <= {s_apb_paddr[2:1], 1'b0};
                    cpuif_wr_data <= s_apb_pwdata;
                end
            end else begin
                cpuif_req <= '0;
                if(cpuif_rd_ack || cpuif_wr_ack) begin
                    is_active <= '0;
                end
            end
        end
    end
    assign cpuif_wr_biten = '1;

    // Response
    assign s_apb_pready = cpuif_rd_ack | cpuif_wr_ack;
    assign s_apb_prdata = cpuif_rd_data;
    assign s_apb_pslverr = cpuif_rd_err | cpuif_wr_err;

    logic cpuif_req_masked;

    // Read & write latencies are balanced. Stalls not required
    assign cpuif_req_stall_rd = '0;
    assign cpuif_req_stall_wr = '0;
    assign cpuif_req_masked = cpuif_req
                            & !(!cpuif_req_is_wr & cpuif_req_stall_rd)
                            & !(cpuif_req_is_wr & cpuif_req_stall_wr);

    //--------------------------------------------------------------------------
    // Address Decode
    //--------------------------------------------------------------------------
    typedef struct {
        logic SRC;
        logic RESULT;
        logic CMD;
    } decoded_reg_strb_t;
    decoded_reg_strb_t decoded_reg_strb;
    logic decoded_req;
    logic decoded_req_is_wr;
    logic [15:0] decoded_wr_data;
    logic [15:0] decoded_wr_biten;

    always_comb begin
        decoded_reg_strb.SRC = cpuif_req_masked & (cpuif_addr == 3'h0);
        decoded_reg_strb.RESULT = cpuif_req_masked & (cpuif_addr == 3'h2);
        decoded_reg_strb.CMD = cpuif_req_masked & (cpuif_addr == 3'h4);
    end

    // Pass down signals to next stage
    assign decoded_req = cpuif_req_masked;
    assign decoded_req_is_wr = cpuif_req_is_wr;
    assign decoded_wr_data = cpuif_wr_data;
    assign decoded_wr_biten = cpuif_wr_biten;

    //--------------------------------------------------------------------------
    // Field logic
    //--------------------------------------------------------------------------
    typedef struct {
        struct {
            struct {
                logic [4:0] next;
                logic load_next;
            } op;
            struct {
                logic next;
                logic load_next;
            } start;
            struct {
                logic next;
                logic load_next;
            } done;
            struct {
                logic [6:0] next;
                logic load_next;
            } reserved;
        } CMD;
    } field_combo_t;
    field_combo_t field_combo;

    typedef struct {
        struct {
            struct {
                logic [4:0] value;
            } op;
            struct {
                logic value;
            } start;
            struct {
                logic value;
            } done;
            struct {
                logic [6:0] value;
            } reserved;
        } CMD;
    } field_storage_t;
    field_storage_t field_storage;

    // Field: TinyALUreg.CMD.op
    always_comb begin
        automatic logic [4:0] next_c = field_storage.CMD.op.value;
        automatic logic load_next_c = '0;
        if(decoded_reg_strb.CMD && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.CMD.op.value & ~decoded_wr_biten[4:0]) | (decoded_wr_data[4:0] & decoded_wr_biten[4:0]);
            load_next_c = '1;
        end else begin // HW Write
            next_c = hwif_in.CMD.op.next;
            load_next_c = '1;
        end
        field_combo.CMD.op.next = next_c;
        field_combo.CMD.op.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.CMD.op.value <= 5'h0;
        end else if(field_combo.CMD.op.load_next) begin
            field_storage.CMD.op.value <= field_combo.CMD.op.next;
        end
    end
    assign hwif_out.CMD.op.value = field_storage.CMD.op.value;
    // Field: TinyALUreg.CMD.start
    always_comb begin
        automatic logic [0:0] next_c = field_storage.CMD.start.value;
        automatic logic load_next_c = '0;
        if(decoded_reg_strb.CMD && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.CMD.start.value & ~decoded_wr_biten[5:5]) | (decoded_wr_data[5:5] & decoded_wr_biten[5:5]);
            load_next_c = '1;
        end else begin // HW Write
            next_c = hwif_in.CMD.start.next;
            load_next_c = '1;
        end
        field_combo.CMD.start.next = next_c;
        field_combo.CMD.start.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.CMD.start.value <= 1'h0;
        end else if(field_combo.CMD.start.load_next) begin
            field_storage.CMD.start.value <= field_combo.CMD.start.next;
        end
    end
    assign hwif_out.CMD.start.value = field_storage.CMD.start.value;
    // Field: TinyALUreg.CMD.done
    always_comb begin
        automatic logic [0:0] next_c = field_storage.CMD.done.value;
        automatic logic load_next_c = '0;
        if(decoded_reg_strb.CMD && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.CMD.done.value & ~decoded_wr_biten[6:6]) | (decoded_wr_data[6:6] & decoded_wr_biten[6:6]);
            load_next_c = '1;
        end else begin // HW Write
            next_c = hwif_in.CMD.done.next;
            load_next_c = '1;
        end
        field_combo.CMD.done.next = next_c;
        field_combo.CMD.done.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.CMD.done.value <= 1'h0;
        end else if(field_combo.CMD.done.load_next) begin
            field_storage.CMD.done.value <= field_combo.CMD.done.next;
        end
    end
    assign hwif_out.CMD.done.value = field_storage.CMD.done.value;
    // Field: TinyALUreg.CMD.reserved
    always_comb begin
        automatic logic [6:0] next_c = field_storage.CMD.reserved.value;
        automatic logic load_next_c = '0;
        if(decoded_reg_strb.CMD && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.CMD.reserved.value & ~decoded_wr_biten[14:8]) | (decoded_wr_data[14:8] & decoded_wr_biten[14:8]);
            load_next_c = '1;
        end else begin // HW Write
            next_c = hwif_in.CMD.reserved.next;
            load_next_c = '1;
        end
        field_combo.CMD.reserved.next = next_c;
        field_combo.CMD.reserved.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.CMD.reserved.value <= 7'h0;
        end else if(field_combo.CMD.reserved.load_next) begin
            field_storage.CMD.reserved.value <= field_combo.CMD.reserved.next;
        end
    end
    assign hwif_out.CMD.reserved.value = field_storage.CMD.reserved.value;

    //--------------------------------------------------------------------------
    // Write response
    //--------------------------------------------------------------------------
    assign cpuif_wr_ack = decoded_req & decoded_req_is_wr;
    // Writes are always granted with no error response
    assign cpuif_wr_err = '0;

    //--------------------------------------------------------------------------
    // Readback
    //--------------------------------------------------------------------------

    logic readback_err;
    logic readback_done;
    logic [15:0] readback_data;
    
    // Assign readback values to a flattened array
    logic [15:0] readback_array[3];
    assign readback_array[0][7:0] = (decoded_reg_strb.SRC && !decoded_req_is_wr) ? hwif_in.SRC.data0.next : '0;
    assign readback_array[0][15:8] = (decoded_reg_strb.SRC && !decoded_req_is_wr) ? hwif_in.SRC.data1.next : '0;
    assign readback_array[1][15:0] = (decoded_reg_strb.RESULT && !decoded_req_is_wr) ? hwif_in.RESULT.data.next : '0;
    assign readback_array[2][4:0] = (decoded_reg_strb.CMD && !decoded_req_is_wr) ? field_storage.CMD.op.value : '0;
    assign readback_array[2][5:5] = (decoded_reg_strb.CMD && !decoded_req_is_wr) ? field_storage.CMD.start.value : '0;
    assign readback_array[2][6:6] = (decoded_reg_strb.CMD && !decoded_req_is_wr) ? field_storage.CMD.done.value : '0;
    assign readback_array[2][7:7] = '0;
    assign readback_array[2][14:8] = (decoded_reg_strb.CMD && !decoded_req_is_wr) ? field_storage.CMD.reserved.value : '0;
    assign readback_array[2][15:15] = '0;

    // Reduce the array
    always_comb begin
        automatic logic [15:0] readback_data_var;
        readback_done = decoded_req & ~decoded_req_is_wr;
        readback_err = '0;
        readback_data_var = '0;
        for(int i=0; i<3; i++) readback_data_var |= readback_array[i];
        readback_data = readback_data_var;
    end

    assign cpuif_rd_ack = readback_done;
    assign cpuif_rd_data = readback_data;
    assign cpuif_rd_err = readback_err;
endmodule