const std = @import("std");
const prng = std.rand.DefaultPrng;
const time = std.time;
const print = std.debug.print;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    // 乱数を発生させる
    var rand = prng.init(@intCast(u64, time.milliTimestamp()));
    var arrayAnswer = [5]u8{0,0,0,0,0};

    // Whileでまわして乱数を配列に入れる
    var i: u8 = 0;
    while ( i < 5) {
        var num = rand.random().int(u8) % 10;
        arrayAnswer[i] = num;
        i = i + 1;
    }

    try stdout.print("Welcome!! 数当てゲーム!\n", .{});
    try stdout.print("ランダム生成された５つの数字を当ててね！\n", .{});

    var buf: [10]u8 = undefined;

    while(true) {
        try stdout.print("\n", .{});
        try stdout.print("それでは、5桁の数字を入力してください:", .{});

        if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
            try stdout.print("入力された数値は、{s}ですね！\n", .{user_input});

            var userInputArray = [5]u8{0,0,0,0,0};

            // Whileでまわして乱数を配列に入れる
            var k: u8 = 0;
            while ( k < 5) {
                // user入力を１文字毎にスプリットしてIntにキャストすると期待通りの数値ならない
                // なぜかその数字から48を引けば期待通りの数値になる。
                userInputArray[k] = @intCast(u8, user_input[k]) - 48;
                k = k + 1;
            }

            // Check
            var checkArray = [5]u8{0,0,0,0,0};
            var judge = "o";
            var j: u8 = 0;
            while ( j < 5) {
                if (arrayAnswer[j] == userInputArray[j]) {
                    checkArray[j] = 1;
                } else {
                    checkArray[j] = 0;
                    judge = "x";
                }

                j = j + 1;
            }

            try stdout.print("判定は、、、\n", .{});
            try stdout.print("、、、\n", .{});
            try stdout.print("{s}\n\n", .{judge});
            try stdout.print("[詳細]\n", .{});

            j = 0;
            while ( j < 5) {
                var judgeChar = "x";
                if (checkArray[j] == 1) {
                    judgeChar = "o";
                }

                try stdout.print("{}st... {s}\n", .{j, judgeChar});
                j = j + 1;
            }

            if (judge == "o") {
                try stdout.print("おめでとうございます！正解です！！\n", .{});
                break;
            } else {
                try stdout.print("正解は、、、{}{}{}{}{}\n", .{
                    arrayAnswer[0],
                    arrayAnswer[1],
                    arrayAnswer[2],
                    arrayAnswer[3],
                    arrayAnswer[4]
                    });
            }
        } else {
            try stdout.print("もう一度、5桁の数字を入力してください\n", .{});
        }
    }
}

