const std = @import("std");
const lib_nlopt = @import("lib_nlopt");
pub const c = lib_nlopt.nlopt;

pub const Error = error{
    Failure,
    InvalidArgs,
    OutOfMemory,
    RoundoffLimited,
    ForcedStop,
    SetMinObjectiveFailed,
};

pub const Algorithm = enum {
    GN_DIRECT,
    GN_DIRECT_L,
    GN_DIRECT_L_RAND,
    GN_DIRECT_NOSCAL,
    GN_DIRECT_L_NOSCAL,
    GN_DIRECT_L_RAND_NOSCAL,
    GN_ORIG_DIRECT,
    GN_ORIG_DIRECT_L,
    GD_STOGO,
    GD_STOGO_RAND,
    LD_LBFGS_NOCEDAL,
    LD_LBFGS,
    LN_PRAXIS,
    LD_VAR1,
    LD_VAR2,
    LD_TNEWTON,
    LD_TNEWTON_RESTART,
    LD_TNEWTON_PRECOND,
    LD_TNEWTON_PRECOND_RESTART,
    GN_CRS2_LM,
    GN_MLSL,
    GD_MLSL,
    GN_MLSL_LDS,
    GD_MLSL_LDS,
    LD_MMA,
    LN_COBYLA,
    LN_NEWUOA,
    LN_NEWUOA_BOUND,
    LN_NELDERMEAD,
    LN_SBPLX,
    LN_AUGLAG,
    LD_AUGLAG,
    LN_AUGLAG_EQ,
    LD_AUGLAG_EQ,
    LN_BOBYQA,
    GN_ISRES,
    AUGLAG,
    AUGLAG_EQ,
    G_MLSL,
    G_MLSL_LDS,
    LD_SLSQP,
    LD_CCSAQ,
    GN_ESCH,
    GN_AGS,

    pub fn toC(self: Algorithm) c.nlopt_algorithm {
        return switch (self) {
            .GN_DIRECT => c.NLOPT_GN_DIRECT,
            .GN_DIRECT_L => c.NLOPT_GN_DIRECT_L,
            .GN_DIRECT_L_RAND => c.NLOPT_GN_DIRECT_L_RAND,
            .GN_DIRECT_NOSCAL => c.NLOPT_GN_DIRECT_NOSCAL,
            .GN_DIRECT_L_NOSCAL => c.NLOPT_GN_DIRECT_L_NOSCAL,
            .GN_DIRECT_L_RAND_NOSCAL => c.NLOPT_GN_DIRECT_L_RAND_NOSCAL,
            .GN_ORIG_DIRECT => c.NLOPT_GN_ORIG_DIRECT,
            .GN_ORIG_DIRECT_L => c.NLOPT_GN_ORIG_DIRECT_L,
            .GD_STOGO => c.NLOPT_GD_STOGO,
            .GD_STOGO_RAND => c.NLOPT_GD_STOGO_RAND,
            .LD_LBFGS_NOCEDAL => c.NLOPT_LD_LBFGS_NOCEDAL,
            .LD_LBFGS => c.NLOPT_LD_LBFGS,
            .LN_PRAXIS => c.NLOPT_LN_PRAXIS,
            .LD_VAR1 => c.NLOPT_LD_VAR1,
            .LD_VAR2 => c.NLOPT_LD_VAR2,
            .LD_TNEWTON => c.NLOPT_LD_TNEWTON,
            .LD_TNEWTON_RESTART => c.NLOPT_LD_TNEWTON_RESTART,
            .LD_TNEWTON_PRECOND => c.NLOPT_LD_TNEWTON_PRECOND,
            .LD_TNEWTON_PRECOND_RESTART => c.NLOPT_LD_TNEWTON_PRECOND_RESTART,
            .GN_CRS2_LM => c.NLOPT_GN_CRS2_LM,
            .GN_MLSL => c.NLOPT_GN_MLSL,
            .GD_MLSL => c.NLOPT_GD_MLSL,
            .GN_MLSL_LDS => c.NLOPT_GN_MLSL_LDS,
            .GD_MLSL_LDS => c.NLOPT_GD_MLSL_LDS,
            .LD_MMA => c.NLOPT_LD_MMA,
            .LN_COBYLA => c.NLOPT_LN_COBYLA,
            .LN_NEWUOA => c.NLOPT_LN_NEWUOA,
            .LN_NEWUOA_BOUND => c.NLOPT_LN_NEWUOA_BOUND,
            .LN_NELDERMEAD => c.NLOPT_LN_NELDERMEAD,
            .LN_SBPLX => c.NLOPT_LN_SBPLX,
            .LN_AUGLAG => c.NLOPT_LN_AUGLAG,
            .LD_AUGLAG => c.NLOPT_LD_AUGLAG,
            .LN_AUGLAG_EQ => c.NLOPT_LN_AUGLAG_EQ,
            .LD_AUGLAG_EQ => c.NLOPT_LD_AUGLAG_EQ,
            .LN_BOBYQA => c.NLOPT_LN_BOBYQA,
            .GN_ISRES => c.NLOPT_GN_ISRES,
            .AUGLAG => c.NLOPT_AUGLAG,
            .AUGLAG_EQ => c.NLOPT_AUGLAG_EQ,
            .G_MLSL => c.NLOPT_G_MLSL,
            .G_MLSL_LDS => c.NLOPT_G_MLSL_LDS,
            .LD_SLSQP => c.NLOPT_LD_SLSQP,
            .LD_CCSAQ => c.NLOPT_LD_CCSAQ,
            .GN_ESCH => c.NLOPT_GN_ESCH,
            .GN_AGS => c.NLOPT_GN_AGS,
        };
    }
};

pub const Result = enum {
    Failure,
    InvalidArgs,
    OutOfMemory,
    RoundoffLimited,
    ForcedStop,
    Success,
    StopvalReached,
    FtolReached,
    XtolReached,
    MaxevalReached,
    MaxtimeReached,

    pub fn fromC(c_result: c.nlopt_result) Result {
        return switch (c_result) {
            c.NLOPT_FAILURE => .Failure,
            c.NLOPT_INVALID_ARGS => .InvalidArgs,
            c.NLOPT_OUT_OF_MEMORY => .OutOfMemory,
            c.NLOPT_ROUNDOFF_LIMITED => .RoundoffLimited,
            c.NLOPT_FORCED_STOP => .ForcedStop,
            c.NLOPT_SUCCESS => .Success,
            c.NLOPT_STOPVAL_REACHED => .StopvalReached,
            c.NLOPT_FTOL_REACHED => .FtolReached,
            c.NLOPT_XTOL_REACHED => .XtolReached,
            c.NLOPT_MAXEVAL_REACHED => .MaxevalReached,
            c.NLOPT_MAXTIME_REACHED => .MaxtimeReached,
            else => unreachable,
        };
    }

    pub fn toError(self: Result) Error {
        return switch (self) {
            .Failure => error.Failure,
            .InvalidArgs => error.InvalidArgs,
            .OutOfMemory => error.OutOfMemory,
            .RoundoffLimited => error.RoundoffLimited,
            .ForcedStop => error.ForcedStop,
            else => unreachable,
        };
    }
};

pub const Opt = struct {
    ctx: c.nlopt_opt,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, algorithm: Algorithm, n: u32) !*Opt {
        const opt = try allocator.create(Opt);
        opt.ctx = c.nlopt_create(algorithm.toC(), n) orelse {
            allocator.destroy(opt);
            return error.OutOfMemory;
        };
        opt.allocator = allocator;
        return opt;
    }

    pub fn deinit(self: *Opt) void {
        c.nlopt_destroy(self.ctx);
        self.allocator.destroy(self);
    }

    pub fn setMinObjective(self: *Opt, comptime F: type, context: *F, func: fn(ctx: *F, x: []const f64, grad: ?[]f64) f64) !void {
        const trampoline = struct {
            fn c_callback(n: c.nlopt_algorithm, x: [*c]const f64, grad: [*c]f64, data: ?*anyopaque) callconv(.c) f64 {
                const x_slice = x[0..n];
                var grad_slice: ?[]f64 = null;
                if (grad != null) {
                    grad_slice = grad[0..n];
                }
                const typed_context: *F = @ptrFromInt(@intFromPtr(data.?));
                return func(typed_context, x_slice, grad_slice);
            }
        }.c_callback;

        if (c.nlopt_set_min_objective(self.ctx, trampoline, context) != c.NLOPT_SUCCESS) {
            return error.SetMinObjectiveFailed;
        }
    }

    pub fn setLowerBounds(self: *Opt, lb: []const f64) !void {
        const res = Result.fromC(c.nlopt_set_lower_bounds(self.ctx, lb.ptr));
        if (res != .Success) return res.toError();
    }

    pub fn addInequalityConstraint(self: *Opt, fc: c.nlopt_func, fc_data: ?*anyopaque, tol: f64) !void {
        if (c.nlopt_add_inequality_constraint(self.ctx, fc, fc_data, tol) != c.NLOPT_SUCCESS) {
            return error.InvalidArgs;
        }
    }

    pub fn setXtollRel(self: *Opt, tol: f64) !void {
        const res = Result.fromC(c.nlopt_set_xtol_rel(self.ctx, tol));
        if (res != .Success) return res.toError();
    }

    pub fn optimize(self: *Opt, x: []f64) !f64 {
        var opt_f: f64 = undefined;
        const res = Result.fromC(c.nlopt_optimize(self.ctx, x.ptr, &opt_f));
        if (res != .Success and res != .StopvalReached and res != .FtolReached and res != .XtolReached and res != .MaxevalReached and res != .MaxtimeReached) {
            return res.toError();
        }
        return opt_f;
    }
};
