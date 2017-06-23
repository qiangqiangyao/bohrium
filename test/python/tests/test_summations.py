import util
import functools
import operator


class test_sums:
    """ Test reduction of sum(), prod(), any(), and all()"""
    def init(self):
        for cmd, shape in util.gen_random_arrays("R", 3, dtype="np.float32"):
            cmd = "R = bh.random.RandomState(42); a = %s; " % cmd
            for op in ["sum", "prod", "all", "any"]:
                yield (cmd, op, None)
                for axis in range(len(shape)):
                    yield (cmd, op, axis)

    def test_func(self, arg):
        (cmd, op, axis) = arg
        if axis is None:
            cmd += "res = M.%s(a)" % op
        else:
            cmd += "res = M.%s(a, axis=%d)" % (op, axis)
        return cmd

    def test_method(self, arg):
        (cmd, op, axis) = arg
        if axis is None:
            cmd += "res = a.%s()" % op
        else:
            cmd += "res = a.%s(axis=%d)" % (op, axis)
        return cmd


class test_argminmax:
    def init(self):
        for cmd, shape in util.gen_random_arrays("R", 3, dtype="np.float32"):
            cmd = "R = bh.random.RandomState(42); a = %s; " % cmd
            nelem = functools.reduce(operator.mul, shape)
            if nelem > 0:
                yield (cmd)

    def test_min(self, cmd):
        return cmd + "res = M.argmin(a)"

    def test_max(self, cmd):
        return cmd + "res = M.argmax(a)"

