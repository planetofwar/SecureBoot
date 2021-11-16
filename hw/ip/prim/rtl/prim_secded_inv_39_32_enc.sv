// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);

  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ~^(data_o & 39'h002606BD25);
    data_o[33] = ~^(data_o & 39'h00DEBA8050);
    data_o[34] = ~^(data_o & 39'h00413D89AA);
    data_o[35] = ~^(data_o & 39'h0031234ED1);
    data_o[36] = ~^(data_o & 39'h00C2C1323B);
    data_o[37] = ~^(data_o & 39'h002DCC624C);
    data_o[38] = ~^(data_o & 39'h0098505586);
  end

endmodule : prim_secded_inv_39_32_enc
