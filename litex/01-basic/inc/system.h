#ifndef __SYSTEM_H
#define __SYSTEM_H
#define CSR_ACCESSORS_DEFINED 1

/* 0x40020000 */
#define CSR_BASE FPGA_PERIPH_BASE

/* CSR subregisters (a.k.a. "simple CSRs") are embedded inside uint32_t
 * aligned locations: */
#define MMPTR(a) (*((volatile uint32_t *)(a)))

static inline void csr_write_simple(unsigned long v, unsigned long a)
{
    MMPTR(a) = v;
}

static inline unsigned long csr_read_simple(unsigned long a)
{
    return MMPTR(a);
}

#endif  /* __SYSTEM_H */
