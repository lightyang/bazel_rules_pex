load(
    "@//pex:pex_rules.bzl",
    "pex_binary",
    "pex_library",
    "pex_test",
    "pex_pytest",
)

pex_binary(
    name = "foo",
    srcs = ["foo.py"],
    deps = [
        ":libbar",
    ]
)

pex_library(
    name = "libbar",
    srcs = ["bar/bar.py"],
    strip_prefixes = [
        "./bar",
    ],
)

pex_library(
    name = "libfoo",
    srcs = ["foo.py"],
    reqs = [
        "flask",
        "pyyaml",
    ],
)

pex_pytest(
    name = "foo_test",
    srcs = ["foo_test.py"],
    args = ["--strict"],
    deps = [":libfoo"],
    size = "small",
)
