// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `topgen.py` tool


// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
    '{"rv_dm__regs", '{
        '{32'h41200000, 32'h41200fff}
    }},
    '{"rv_dm__rom", '{
        '{32'h00010000, 32'h00010fff}
    }},
    '{"rom_ctrl__rom", '{
        '{32'h00008000, 32'h0000bfff}
    }},
    '{"rom_ctrl__regs", '{
        '{32'h411e0000, 32'h411e0fff}
    }},
    '{"flash_ctrl__core", '{
        '{32'h41000000, 32'h41000fff}
    }},
    '{"flash_ctrl__prim", '{
        '{32'h41008000, 32'h41008fff}
    }},
    '{"flash_ctrl__mem", '{
        '{32'h20000000, 32'h200fffff}
    }},
    '{"hmac", '{
        '{32'h41110000, 32'h41110fff}
    }},
    '{"kmac", '{
        '{32'h41120000, 32'h41120fff}
    }},
    '{"aes", '{
        '{32'h41100000, 32'h41100fff}
    }},
    '{"entropy_src", '{
        '{32'h41160000, 32'h41160fff}
    }},
    '{"csrng", '{
        '{32'h41150000, 32'h41150fff}
    }},
    '{"edn0", '{
        '{32'h41170000, 32'h41170fff}
    }},
    '{"edn1", '{
        '{32'h41180000, 32'h41180fff}
    }},
    '{"rv_plic", '{
        '{32'h48000000, 32'h4fffffff}
    }},
    '{"otbn", '{
        '{32'h411d0000, 32'h411dffff}
    }},
    '{"keymgr", '{
        '{32'h41130000, 32'h41130fff}
    }},
    '{"rv_core_ibex__cfg", '{
        '{32'h411f0000, 32'h411f0fff}
    }},
    '{"sram_ctrl_main__regs", '{
        '{32'h411c0000, 32'h411c0fff}
    }},
    '{"sram_ctrl_main__ram", '{
        '{32'h10000000, 32'h1001ffff}
    }},
    '{"uart0", '{
        '{32'h40000000, 32'h40000fff}
    }},
    '{"uart1", '{
        '{32'h40010000, 32'h40010fff}
    }},
    '{"uart2", '{
        '{32'h40020000, 32'h40020fff}
    }},
    '{"uart3", '{
        '{32'h40030000, 32'h40030fff}
    }},
    '{"i2c0", '{
        '{32'h40080000, 32'h40080fff}
    }},
    '{"i2c1", '{
        '{32'h40090000, 32'h40090fff}
    }},
    '{"i2c2", '{
        '{32'h400a0000, 32'h400a0fff}
    }},
    '{"pattgen", '{
        '{32'h400e0000, 32'h400e0fff}
    }},
    '{"pwm_aon", '{
        '{32'h40450000, 32'h40450fff}
    }},
    '{"gpio", '{
        '{32'h40040000, 32'h40040fff}
    }},
    '{"spi_device", '{
        '{32'h40050000, 32'h40051fff}
    }},
    '{"spi_host0", '{
        '{32'h40060000, 32'h40060fff}
    }},
    '{"spi_host1", '{
        '{32'h40070000, 32'h40070fff}
    }},
    '{"rv_timer", '{
        '{32'h40100000, 32'h40100fff}
    }},
    '{"usbdev", '{
        '{32'h40110000, 32'h40110fff}
    }},
    '{"pwrmgr_aon", '{
        '{32'h40400000, 32'h40400fff}
    }},
    '{"rstmgr_aon", '{
        '{32'h40410000, 32'h40410fff}
    }},
    '{"clkmgr_aon", '{
        '{32'h40420000, 32'h40420fff}
    }},
    '{"pinmux_aon", '{
        '{32'h40460000, 32'h40460fff}
    }},
    '{"otp_ctrl__core", '{
        '{32'h40130000, 32'h40131fff}
    }},
    '{"otp_ctrl__prim", '{
        '{32'h40132000, 32'h40132fff}
    }},
    '{"lc_ctrl", '{
        '{32'h40140000, 32'h40140fff}
    }},
    '{"sensor_ctrl", '{
        '{32'h40490000, 32'h40490fff}
    }},
    '{"alert_handler", '{
        '{32'h40150000, 32'h40150fff}
    }},
    '{"sram_ctrl_ret_aon__regs", '{
        '{32'h40500000, 32'h40500fff}
    }},
    '{"sram_ctrl_ret_aon__ram", '{
        '{32'h40600000, 32'h40600fff}
    }},
    '{"aon_timer_aon", '{
        '{32'h40470000, 32'h40470fff}
    }},
    '{"sysrst_ctrl_aon", '{
        '{32'h40430000, 32'h40430fff}
    }},
    '{"adc_ctrl_aon", '{
        '{32'h40440000, 32'h40440fff}
    }},
    '{"ast", '{
        '{32'h40480000, 32'h40480fff}
    }}};

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
    '{"rv_core_ibex__corei", 0, '{
        "rom_ctrl__rom",
        "rv_dm__rom",
        "sram_ctrl_main__ram",
        "flash_ctrl__mem"}}
    ,
    '{"rv_core_ibex__cored", 1, '{
        "rom_ctrl__rom",
        "rom_ctrl__regs",
        "rv_dm__rom",
        "rv_dm__regs",
        "sram_ctrl_main__ram",
        "uart0",
        "uart1",
        "uart2",
        "uart3",
        "i2c0",
        "i2c1",
        "i2c2",
        "pattgen",
        "gpio",
        "spi_device",
        "spi_host0",
        "spi_host1",
        "rv_timer",
        "usbdev",
        "pwrmgr_aon",
        "rstmgr_aon",
        "clkmgr_aon",
        "pinmux_aon",
        "otp_ctrl__core",
        "otp_ctrl__prim",
        "lc_ctrl",
        "sensor_ctrl",
        "alert_handler",
        "ast",
        "sram_ctrl_ret_aon__ram",
        "sram_ctrl_ret_aon__regs",
        "aon_timer_aon",
        "adc_ctrl_aon",
        "sysrst_ctrl_aon",
        "pwm_aon",
        "flash_ctrl__core",
        "flash_ctrl__prim",
        "flash_ctrl__mem",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "otbn",
        "keymgr",
        "kmac",
        "sram_ctrl_main__regs",
        "rv_core_ibex__cfg"}}
    ,
    '{"rv_dm__sba", 2, '{
        "rom_ctrl__rom",
        "rom_ctrl__regs",
        "rv_dm__regs",
        "sram_ctrl_main__ram",
        "uart0",
        "uart1",
        "uart2",
        "uart3",
        "i2c0",
        "i2c1",
        "i2c2",
        "pattgen",
        "gpio",
        "spi_device",
        "spi_host0",
        "spi_host1",
        "rv_timer",
        "usbdev",
        "pwrmgr_aon",
        "rstmgr_aon",
        "clkmgr_aon",
        "pinmux_aon",
        "otp_ctrl__core",
        "otp_ctrl__prim",
        "lc_ctrl",
        "sensor_ctrl",
        "alert_handler",
        "ast",
        "sram_ctrl_ret_aon__ram",
        "sram_ctrl_ret_aon__regs",
        "aon_timer_aon",
        "adc_ctrl_aon",
        "sysrst_ctrl_aon",
        "pwm_aon",
        "flash_ctrl__core",
        "flash_ctrl__prim",
        "flash_ctrl__mem",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "otbn",
        "keymgr",
        "kmac",
        "sram_ctrl_main__regs",
        "rv_core_ibex__cfg"}}
};
