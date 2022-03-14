workspace(name="cfalib")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.5.0/rules_python-0.5.0.tar.gz",
    sha256 = "cd6730ed53a002c56ce4e2f396ba3b3be262fd7cb68339f0377a45e8227fe332",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
container_repositories()

load("@io_bazel_rules_docker//python3:image.bzl", _py_image_repos = "repositories")
_py_image_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
    name = "python3.10-base",
    registry = "index.docker.io",
    repository = "python",
    digest = "sha256:17e2d81e5757980ee40742d77dd5d3e1a69ad0d6dacb13064e1b018a6664ec72",
)

load("@rules_python//python:pip.bzl", "pip_install")

pip_install(
   name = "pypi",
   requirements = "//projects/common:requirements.txt",
   python_interpreter_target = "@python_interpreter//:python/install/bin/python3.10"
)

pip_install(
    requirements = "//projects:requirements.txt",
    python_interpreter_target = "@python_interpreter//:python/install/bin/python3.10"
)

load("//:py_interpreter.bzl", "python_build_standalone_interpreter")

python_build_standalone_interpreter(
    name = "python_interpreter",
)

register_toolchains("//:py_toolchain")
