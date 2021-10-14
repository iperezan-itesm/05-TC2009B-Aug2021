module gen_debug #(parameter NUM_CLIENTS=4096)
                  (output logic [NUM_CLIENTS-1:0] onehot_mask [$clog2(NUM_CLIENTS)]
						);

//localparam  NUM_CLIENTS = 4096;

//logic [NUM_CLIENTS-1:0] onehot_mask [$clog2(NUM_CLIENTS)];
//logic [NUM_CLIENTS-1:0] onehot_mask_alt [$clog2(NUM_CLIENTS)];

generate
  genvar binary_index, onehot_index;
    for (binary_index = 0; binary_index < $clog2(NUM_CLIENTS); binary_index ++ ) begin:outter
      for (onehot_index = 0; onehot_index < NUM_CLIENTS; onehot_index ++ ) begin:inner
        assign onehot_mask[binary_index][onehot_index] = onehot_index[binary_index];
      end
    end
endgenerate
/*
initial begin
  int binary_index_int, onehot_index_int;
    for (binary_index_int = 0; binary_index_int < $clog2(NUM_CLIENTS); binary_index_int ++ ) begin:outter_int
      for (onehot_index_int = 0; onehot_index_int < NUM_CLIENTS; onehot_index_int ++ ) begin:inner_int
        //assign onehot_mask[binary_index_int][onehot_index_int] = onehot_index[binary_index_int];
        $display("one_hot_mask[%0d][%0d] = onehot_index[%0d] = %b - onehot_index_int = %0d",binary_index_int,onehot_index_int,binary_index_int,onehot_index_int[binary_index_int],onehot_index_int);
      end
      $display("========================================================");
    end
end
*/
endmodule
