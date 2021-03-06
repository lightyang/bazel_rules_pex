exports_files(["pex_rules.bzl", "testlauncher.sh.template"])

# Can't use pex_binary to build this one, so we have this elaborate ritual:
genrule(
    name = "pex_wrapper",
    srcs = [
        "wrapper/setup.py",
        "wrapper/setup.cfg",
        "wrapper/pex_wrapper.py",
        "wrapper/README",
        "@setuptools_whl//file",
        "@wheel_src//file",
        "@pex_src//file",
        "@requests_src//file",
        "@urllib3_whl//file",
        "@idna_whl//file",
        "@certifi_whl//file",
        "@chardet_whl//file",
    ],
    tools = ["@virtualenv//:virtualenv"],
    outs = ["pex_wrapper.pex"],
    executable = True,
    output_to_bindir = True,
    message = "Bootstrapping pex",
    cmd = """
        set -e
        OUTDIR=$$(cd $(@D) && pwd)
        # Workaround really long shebang lines breaking on linux:
        # Use a /tmp path, but keep the actual venv inside the bazel outdir.
        # Avoids having to worry about cleanup, even if sandboxing is off.
        # `mktemp -t tmp` is used for older OS X versions.
        TMPF=$$(mktemp 2>/dev/null || mktemp -t tmp)
        ln -sf "$$OUTDIR" "$$TMPF"
        VENV="$${TMPF}/venv"

        $(location @virtualenv//:virtualenv) --no-download --quiet --clear "$$VENV"
        PYTHON="$$VENV/bin/python"

        $$PYTHON $$VENV/bin/pip install pex \
            --quiet --no-cache-dir --no-index --build $(@D)/pexbuild \
            --find-links $$(dirname $(location @pex_src//file)) \
            --find-links $$(dirname $(location @setuptools_whl//file))

        # Work around setuptools insistance on writing to the source directory,
        # which is discouraged by Bazel (and annoying)
        cp -r $$(dirname $(location wrapper/setup.py)) $(@D)/.pex_wrapper

        # Use the bootstrapped pex to build pex_wrapper.pex
        $$PYTHON $$VENV/bin/pex $(@D)/.pex_wrapper \
            --disable-cache --no-index -m pex_wrapper -o $@ \
            --find-links $$(dirname $(location @pex_src//file)) \
            --find-links $$(dirname $(location @setuptools_whl//file)) \
            --find-links $$(dirname $(location @requests_src//file)) \
            --find-links $$(dirname $(location @idna_whl//file)) \
            --find-links $$(dirname $(location @urllib3_whl//file)) \
            --find-links $$(dirname $(location @certifi_whl//file)) \
            --find-links $$(dirname $(location @chardet_whl//file)) \
            --find-links $$(dirname $(location @wheel_src//file))
    """,
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "build_wheels",
    srcs = ["build_wheels.sh"],
    visibility = ["//visibility:public"],
)
