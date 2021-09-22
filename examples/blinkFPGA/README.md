# blinkFPGA

This project is a demonstration on how to built, and write, separatelty gateware and
firmware

## Usage

gateware part use `fusesoc` to build bitstream so it's required after `conda
activate` to install `fusesoc` by:

```bash
$ pip3 install -U fusesoc
```

in `GCC_Project` directory: commands are
- `make` will build both bitstream and firmware
- `make gateware` will build only the bitstream
- `make sw` will build only the firmware
- `flash_all` will write both bitstream and firmware into dedicated areas
- `flash_gateware` will write bitstream into `appfpga` area
- `flash_sw` will write firmware into `m4app` area


## Note

Compared to classic project two modifications must be done in the firmware

Only `S3x_Clk_Enable(S3X_FB_21_CLK);` and `S3x_Clk_Enable(S3X_FB_16_CLK);` are
required (no need to write something)

s3x_pwrcfg.c must be updated

```
[PI_FB] =  {
    .name = "FB",
    .pctrl = PI_CTRL(0xa0, 0xa4, 0x200, 0x210, 1, 2, 2),
    .ginfo = PI_GINFO(4, S3X_FB_02_CLK, S3X_FB_16_CLK, S3X_FB_21_CLK , S3X_CLKGATE_FB, 0),
    .cfg_state = PI_SET_SHDN,
},

```

become

```
[PI_FB] =  {
    .name = "FB",
    .pctrl = PI_CTRL(0xa0, 0xa4, 0x200, 0x210, 1, 2, 2),
    .ginfo = PI_GINFO(4, S3X_FB_02_CLK, S3X_FB_16_CLK, S3X_FB_21_CLK , S3X_CLKGATE_FB, 0),
    .cfg_state = PI_NO_CFG,
},
```
