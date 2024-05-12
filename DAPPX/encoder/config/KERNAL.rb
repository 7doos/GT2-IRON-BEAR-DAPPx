```ruby
def mul(a0, a1, a2, a3, rb, stack)
    ax = a0
    ax_rb = ax * (0 + rb)
    r8 = ax_rb
    dx = ax_rb >> 64
    ax_rb = ax * (8 + rb)
    r9 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r8 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (16 + rb)
    r10 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r9 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (24 + rb)
    r11 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r10 >> 64)
    dx = dx + (ax_rb >> 64)

    # storeBlock(R8, R9, R10, R11, 0 + stack)
    r8_r9 = (r9 << 64) | r8
    r10_r11 = (r11 << 64) | r10
    stack[0] = r8_r9
    stack[1] = r10_r11

    ax = a1
    ax_rb = ax * (0 + rb)
    r8 = ax_rb
    dx = ax_rb >> 64
    ax_rb = ax * (8 + rb)
    r9 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r8 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (16 + rb)
    r10 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r9 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (24 + rb)
    r11 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r10 >> 64)
    dx = dx + (ax_rb >> 64)

    r8 = r8 + stack[0]
    r9 = r9 + stack[1]
    r10 = r10 + (stack[1] >> 64)
    r11 = r11 + (stack[1] >> 128)

    # storeBlock(R8, R9, R10, R11, 8 + stack)
    r8_r9 = (r9 << 64) | r8
    r10_r11 = (r11 << 64) | r10
    stack[2] = r8_r9
    stack[3] = r10_r11

    ax = a2
    ax_rb = ax * (0 + rb)
    r8 = ax_rb
    dx = ax_rb >> 64
    ax_rb = ax * (8 + rb)
    r9 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r8 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (16 + rb)
    r10 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r9 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (24 + rb)
    r11 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r10 >> 64)
    dx = dx + (ax_rb >> 64)

    r8 = r8 + stack[2]
    r9 = r9 + stack[3]
    r10 = r10 + (stack[3] >> 64)
    r11 = r11 + (stack[3] >> 128)

    # storeBlock(R8, R9, R10, R11, 16 + stack)
    r8_r9 = (r9 << 64) | r8
    r10_r11 = (r11 << 64) | r10
    stack[4] = r8_r9
    stack[5] = r10_r11

    ax = a3
    ax_rb = ax * (0 + rb)
    r8 = ax_rb
    dx = ax_rb >> 64
    ax_rb = ax * (8 + rb)
    r9 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r8 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (16 + rb)
    r10 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r9 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (24 + rb)
    r11 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r10 >> 64)
    dx = dx + (ax_rb >> 64)

    r8 = r8 + stack[4]
    r9 = r9 + stack[5]
    r10 = r10 + (stack[5] >> 64)
    r11 = r11 + (stack[5] >> 128)

    # storeBlock(R8, R9, R10, R11, 24 + stack)
    r8_r9 = (r9 << 64) | r8
    r10_r11 = (r11 << 64) | r10
    stack[6] = r8_r9
    stack[7] = r10_r11
end

def gfpReduce(stack)
    # m = (T * N') mod R, store m in R8:R9:R10:R11
    ax = ·np + 0
    ax_rb = ax * (0 + stack)
    r8 = ax_rb
    dx = ax_rb >> 64
    ax_rb = ax * (8 + stack)
    r9 = (ax_rb & 0xFFFFFFFFFFFFFFFF) + (r8 >> 64)
    dx = dx + (ax_rb >> 64)
    ax_rb = ax * (16 + stack)
    r10