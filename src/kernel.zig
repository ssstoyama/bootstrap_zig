const BootInfo = @import("boot.zig").BootInfo;
const FrameBufferConfig = @import("boot.zig").FrameBufferConfig;

export fn kernel_main(boot_info: *const BootInfo) void {
    drawBG(boot_info.frame_buffer_config);
    drawHello(boot_info.frame_buffer_config, 100, 100);
    while (true) asm volatile ("hlt");
}

// 画面全体を白で塗りつぶす
pub fn drawBG(frame_buffer_config: *const FrameBufferConfig) void {
    var x: usize = 0;
    while (x < frame_buffer_config.horizontal_resolution) : (x += 1) {
        var y: usize = 0;
        while (y < frame_buffer_config.vertical_resolution) : (y += 1) {
            // ピクセルに白色をセットする
            var p = @ptrCast([*]u8, &frame_buffer_config.frame_buffer[4 * (frame_buffer_config.pixels_per_scan_line * y + x)]);
            p[0] = 255;
            p[1] = 255;
            p[2] = 255;
        }
    }
}

// 黒い文字で Hello, World! を描画する
pub fn drawHello(frame_buffer_config: *const FrameBufferConfig, x: usize, y: usize) void {
    {
        var base_x: usize = x;
        for (words) |word| {
            for (word, 0..) |r, dy| {
                for (r, 0..) |c, dx| {
                    if (c == 0) continue;
                    // ピクセルに白色をセットする
                    var p = @ptrCast([*]u8, &frame_buffer_config.frame_buffer[4 * (frame_buffer_config.pixels_per_scan_line * (y + dy) + (base_x + dx))]);
                    p[0] = 0;
                    p[1] = 0;
                    p[2] = 0;
                }
            }
            base_x += 8;
        }
    }
}

const Word = [10][8]u1;
const words = [_]Word{
    word_h,
    word_e,
    word_l,
    word_l,
    word_o,
    word_space,
    word_w,
    word_o,
    word_r,
    word_l,
    word_d,
    word_exclamation,
};

const word_h = Word{
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
};

const word_l = Word{
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
};

const word_e = Word{
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
};

const word_o = Word{
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
};

const word_space = Word{
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
};

const word_w = Word{
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 1, 1, 0, 1, 1, 0, 1, 1 },
    [8]u1{ 0, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 0, 1, 1, 0, 0, 1, 1, 0 },
};

const word_r = Word{
    [8]u1{ 1, 1, 1, 1, 1, 0, 0, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 1, 0, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 1, 0, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
};

const word_d = Word{
    [8]u1{ 1, 1, 1, 1, 1, 0, 0, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 1, 0, 0 },
    [8]u1{ 1, 1, 0, 0, 1, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 0, 1, 1, 0 },
    [8]u1{ 1, 1, 0, 0, 1, 1, 1, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 1, 0, 0 },
    [8]u1{ 1, 1, 1, 1, 1, 0, 0, 0 },
};

const word_exclamation = Word{
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 0, 0, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
    [8]u1{ 0, 0, 0, 1, 1, 0, 0, 0 },
};
