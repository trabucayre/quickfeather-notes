# QuickLogic EOS S3 examples

## Install

You need to have all required tools: see [here](https://github.com/QuickLogic-Corp/qorc-sdk/blob/master/quickstart.rst#setup-development-environment)

## Env setup

Since examples are build out of *qorc-sdk* tree, you need to export the `SDK` path.

```bash
$ export PROJ_ROOT=/somewhere/qorc-sdk
```

Additionaly, examples are compatibles with *quickfeather* and *Qomu*. To select which board to use (currently only
*blinkCPU* and *blinkCPU_FPGA* are *Qomu* compatible) a second environment variable must be defined by

```bash
$ export BOARD=quickfeather
or
$ export BOARD=qomu
```

## Examples

- *blinkCPU*: standalone MCU application. Blink red led.
- *blinkCPU_FPGA*: both MCU and eFPGA are used (no communication) MCU blink the red led, FPGA the blue one
- *pwmCPU_FPGACLI*: a PWM is instanciated in the eFPGA. `period`, `duty`, `polarity`
  and `enable` are configured by MCU using `CLI` interface.
- *blinkFPGA*: eFPGA is used to blink blue led. MCU is only used to configure
  pinmux and clk freq. gateware is written in `appfpga` flash area and firmware
  in `m4app`
