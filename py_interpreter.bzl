OSX_OS_NAME = "mac os x"
LINUX_OS_NAME = "linux"

def _python_build_standalone_interpreter_impl(repository_ctx):
    os_name = repository_ctx.os.name.lower()

    if os_name == OSX_OS_NAME:
        url = "https://github.com/indygreg/python-build-standalone/releases/download/20211017/cpython-3.10.0-x86_64-apple-darwin-pgo+lto-20211017T1616.tar.zst"
        integrity_shasum = "743dfc710d5f6b0fba9183962341e890794b943931acd1f3d0f76a33ebf34983"
    elif os_name == LINUX_OS_NAME:
        url = "https://github.com/indygreg/python-build-standalone/releases/download/20211017/cpython-3.10.0-x86_64-unknown-linux-gnu-pgo+lto-20211017T1616.tar.zst"
        integrity_shasum = "ba898cb849b02e9f6f567a3151435d5f6ba4dd3962890a2e45503677c6bd203c"
    else:
        fail("OS '{}' is not supported.".format(os_name))

    repository_ctx.download(
        url = [url],
        sha256 = integrity_shasum,
        output = "python.tar.zst",
    )

    # TODO(Jonathon): NOT HERMETIC. Need to install 'unzstd' in rule and use it.
    unzstd_bin_path = repository_ctx.which("unzstd")
    if unzstd_bin_path == None:
        fail("On OSX and Linux this Python toolchain requires that the zstd and unzstd exes are available on the $PATH, but it was not found.")

    # NOTE: *Not Hermetic*. Need to install 'unzstd' in rule and use it.
    res = repository_ctx.execute([unzstd_bin_path, "python.tar.zst"])

    if res.return_code:
        fail("Error decompressing with zstd" + res.stdout + res.stderr)

    repository_ctx.extract(archive = "python.tar")
    repository_ctx.delete("python.tar")
    repository_ctx.delete("python.tar.zst")

    # NOTE: 'json' library is only available in Bazel 4.*.
    python_build_data = json.decode(repository_ctx.read("python/PYTHON.json"))

    BUILD_FILE_CONTENT = """
filegroup(
    name = "files",
    srcs = glob(["install/**"], exclude = ["**/* *"]),
    visibility = ["//visibility:public"],
)
filegroup(
    name = "interpreter",
    srcs = ["python/{interpreter_path}"],
    visibility = ["//visibility:public"],
)
""".format(interpreter_path = python_build_data["python_exe"])

    repository_ctx.file("BUILD.bazel", BUILD_FILE_CONTENT)
    return None

python_build_standalone_interpreter = repository_rule(
    implementation = _python_build_standalone_interpreter_impl,
    attrs = {},
)
