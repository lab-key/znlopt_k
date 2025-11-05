const std = @import("std");
const nlopt = @import("lib_znlopt");

// Data for the objective function
const MyFuncData = struct {
    a: f64,
};

// Objective function: f(x) = a * x[0]^2
// grad[0] = 2 * a * x[0]
fn my_func(n: u32, x: [*c]const f64, grad: [*c]f64, func_data: ?*anyopaque) callconv(.c) f64 {
    _ = n;
    const data: *MyFuncData = @ptrCast(@alignCast(func_data.?));

    if (grad) |g| {
        g[0] = 2 * data.a * x[0];
    }

    return data.a * x[0] * x[0];
}

pub fn main() !void {
    const n: u32 = 1; // Dimensionality of the problem
    var x: [1]f64 = .{ 1.234 }; // Initial guess
    var minf: f64 = 0.0; // Minimum objective value

    var my_data = MyFuncData{ .a = 2.0 };

    // Create an NLopt optimizer (e.g., NLOPT_LD_MMA for local gradient-based optimization)
    const opt = nlopt.nlopt.nlopt_create(nlopt.nlopt.NLOPT_LD_MMA, n);
    if (opt == null) {
        std.debug.print("NLopt failed to create optimizer\n", .{});
        return error.NloptError;
    }

    // Set the objective function to minimize
    const set_obj_res = nlopt.nlopt.nlopt_set_min_objective(opt, my_func, &my_data);
    if (set_obj_res != nlopt.nlopt.NLOPT_SUCCESS) {
        std.debug.print("NLopt failed to set objective: {}\n", .{set_obj_res});
        nlopt.nlopt.nlopt_destroy(opt);
        return error.NloptError;
    }

    // Set bounds (e.g., -10 <= x <= 10)
    var lb: [1]f64 = .{ -10.0 };
    var ub: [1]f64 = .{ 10.0 };
    const set_lb_res = nlopt.nlopt.nlopt_set_lower_bounds(opt, &lb[0]);
    if (set_lb_res != nlopt.nlopt.NLOPT_SUCCESS) {
        std.debug.print("NLopt failed to set lower bounds: {}\n", .{set_lb_res});
        nlopt.nlopt.nlopt_destroy(opt);
        return error.NloptError;
    }
    const set_ub_res = nlopt.nlopt.nlopt_set_upper_bounds(opt, &ub[0]);
    if (set_ub_res != nlopt.nlopt.NLOPT_SUCCESS) {
        std.debug.print("NLopt failed to set upper bounds: {}\n", .{set_ub_res});
        nlopt.nlopt.nlopt_destroy(opt);
        return error.NloptError;
    }

    // Set stopping criteria (e.g., absolute tolerance on function value)
    const set_ftol_res = nlopt.nlopt.nlopt_set_ftol_abs(opt, 1e-6);
    if (set_ftol_res != nlopt.nlopt.NLOPT_SUCCESS) {
        std.debug.print("NLopt failed to set ftol_abs: {}\n", .{set_ftol_res});
        nlopt.nlopt.nlopt_destroy(opt);
        return error.NloptError;
    }

    // Perform the optimization
    const result = nlopt.nlopt.nlopt_optimize(opt, &x[0], &minf);

    if (result < 0) {
        std.debug.print("NLopt optimization failed with result: {}\n", .{result});
    } else {
        std.debug.print("NLopt optimization successful!\n", .{});
        std.debug.print("Found minimum at x = {d}, f(x) = {d}\n", .{ x[0], minf });
    }

    // Clean up
    nlopt.nlopt.nlopt_destroy(opt);
}