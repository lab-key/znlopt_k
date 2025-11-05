const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const lib = b.addLibrary(.{
        .name = "lib_nlopt",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        }),
    });

    lib.root_module.addCSourceFiles(.{
        .files = &.{ 
            "src/lib/nlopt/auglag.c",
            "src/lib/nlopt/bobyqa.c",
            "src/lib/nlopt/ccsa_quadratic.c",
            "src/lib/nlopt/cdirect.c",
            "src/lib/nlopt/cobyla.c",
            "src/lib/nlopt/crs.c",
            "src/lib/nlopt/deprecated.c",
            "src/lib/nlopt/direct_wrap.c",
            "src/lib/nlopt/DIRect.c",
            "src/lib/nlopt/DIRserial.c",
            "src/lib/nlopt/DIRsubrout.c",
            "src/lib/nlopt/esch.c",
            "src/lib/nlopt/f77api.c",
            "src/lib/nlopt/general.c",
            "src/lib/nlopt/hybrid.c",
            "src/lib/nlopt/isres.c",
            "src/lib/nlopt/mlsl.c",
            "src/lib/nlopt/mma.c",
            "src/lib/nlopt/mssubs.c",
            "src/lib/nlopt/mt19937ar.c",
            "src/lib/nlopt/newuoa.c",
            "src/lib/nlopt/nldrmd.c",
            "src/lib/nlopt/optimize.c",
            "src/lib/nlopt/options.c",
            "src/lib/nlopt/plip.c",
            "src/lib/nlopt/plis.c",
            "src/lib/nlopt/pnet.c",
            "src/lib/nlopt/praxis.c",
            "src/lib/nlopt/pssubs.c",
            "src/lib/nlopt/qsort_r.c",
            "src/lib/nlopt/redblack.c",
            "src/lib/nlopt/rescale.c",
            "src/lib/nlopt/sbplx.c",
            "src/lib/nlopt/slsqp.c",
            "src/lib/nlopt/sobolseq.c",
            "src/lib/nlopt/stop.c",
            "src/lib/nlopt/timer.c",
        },
        .flags = &.{ 
            "-std=c11",
            "-D_GNU_SOURCE",
        },
    });

    lib.root_module.addCSourceFiles(.{
        .files = &.{ 
            "src/lib/nlopt/ags.cc",
            "src/lib/nlopt/evolvent.cc",
            "src/lib/nlopt/global.cc",
            "src/lib/nlopt/linalg.cc",
            "src/lib/nlopt/local_optimizer.cc",
            "src/lib/nlopt/local.cc",
            "src/lib/nlopt/stogo.cc",
            "src/lib/nlopt/solver.cc",
            "src/lib/nlopt/tools.cc",
        },
        .flags = &.{ 
            "-std=c++17",
            "-D_GNU_SOURCE",
        },
    });

    lib.addIncludePath(b.path("include"));
    lib.addIncludePath(b.path("src/lib/nlopt"));

    lib.linkLibC();

    b.installArtifact(lib);

    // --- Create and export the lib_znlopt Zig module ---
    const znlopt_module = b.createModule(.{
        .root_source_file = b.path("zig/c.zig"),
        .target = target,
        .optimize = optimize,
    });

    znlopt_module.addIncludePath(b.path("include"));
    znlopt_module.addIncludePath(b.path("src/lib/nlopt"));
    znlopt_module.linkLibrary(lib);

    b.modules.put("lib_znlopt", znlopt_module) catch @panic("failed to register lib_znlopt module");

    // --- Build an example executable ---
    const example_exe = b.addExecutable(.{
        .name = "nlopt_example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("zig/example.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ 
                .{ .name = "lib_znlopt", .module = znlopt_module },
            },
        }),
    });

    b.installArtifact(example_exe);

    const run_example_step = b.addRunArtifact(example_exe);
    const run_step = b.step("run", "Run the nlopt example");
    run_step.dependOn(&run_example_step.step);
}
