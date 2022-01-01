# LiteX / QuickLogic EOS S3 examples

## Install

You need to have all required tools: see [here](https://github.com/QuickLogic-Corp/qorc-sdk/blob/master/quickstart.rst#setup-development-environment)

You also needs to have an up-to-date [LiteX installation](https://github.com/enjoy-digital/litex/wiki/Installation)

## Env setup

Since examples are build out of *qorc-sdk* tree, you need to export the `SDK` path.


```bash
$ export QORC_SDK=/somewhere/qorc-sdk
```

Additionaly, for futur works, board type must be provided (currently only **quickfeather**):

```bash
$ export BOARD=quickfeather
```

## building example

- Move to `xxx/GCC_Project`
- with **conda** activated simply use `make` and wait
- with the **quickfeather** in bootloader mode: `make flash_all`

It's possible to flash independently the **FPGA** or the **MCU**:

```bash
$ make flash_software # only flash MCU area 
$ make flash_gateware # only flash FPGA area
```

## Examples

- *01-basic*: example mixing QuickLogic's CLI and LiteX's gateware: toggle or configure manually LEDs
- *02-IRQ*: same example. Adds FPGA -> MCU IRQ: displays a message when user
  button is pushed.
