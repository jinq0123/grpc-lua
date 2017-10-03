from conans import ConanFile, CMake

class GrpcluaConan(ConanFile):
    name = "grpc-lua"
    version = "0.1"
    license = "BSD-3-Clause"
    url = "https://github.com/jinq0123/grpc-lua"
    description = "The Lua gRPC binding"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = "shared=True"
    generators = "cmake", "Premake"  # A custom generator: PremakeGen/0.1@memsharded/testing
    build_requires = "PremakeGen/0.1@memsharded/testing"
    exports_sources = "src/*", "CMakeLists.txt"

    # conan remote add jinq0123 https://api.bintray.com/conan/jinq0123/test
    requires = ("grpc_cb_core/0.1@jinq0123/testing",
                "lua-cpp/5.3.4@jinq0123/testing",
				"Protobuf/3.4.1@jinq0123/testing",
                "lua-intf/0.1@jinq0123/testing")
                
    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        self.output.info("os=%s compiler=%s build_type=%s arch=%s" % (
            self.info.settings.os, self.info.settings.compiler,
            self.info.settings.build_type, self.info.settings.arch))

    def package(self):
        # no *.h
        self.copy("*.lib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.dylib*", dst="lib", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["grpc_lua"]
