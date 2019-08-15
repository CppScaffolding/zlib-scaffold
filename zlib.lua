-- package geniefile for zlib

zlib_script = path.getabsolute(path.getdirectory(_SCRIPT))
zlib_root = path.join(zlib_script, "zlib")

zlib_includedirs = {
	path.join(zlib_script, "config"),
	zlib_root,
	path.join(zlib_root, "contrib", "minizip"),
	path.join(zlib_root, "contrib", "iostream3"),
}

zlib_defines = {}
zlib_libdirs = {}
zlib_links = {}

newoption {
	trigger = "zlib-with-assembly",
	description = "Enable ZLIB assembly optimizations.",
}

----
return {
	_add_includedirs = function()
		includedirs { zlib_includedirs }
	end,

	_add_defines = function()
		defines { zlib_defines }
	end,

	_add_libdirs = function()
		libdirs { zlib_libdirs }
	end,

	_add_external_links = function()
		links { zlib_links }
	end,

	_add_self_links = function()
		links { "z", "zfstream", "minizip" }
	end,

	_create_projects = function()

	group "thirdparty"
	project "z"
		kind "StaticLib"
		language "C"
		flags {}

		configuration {}

		includedirs {
			zlib_includedirs,
		}

		defines {
			"STDC",
		}

		files {
			path.getabsolute(path.join(path.getdirectory(_SCRIPT), "config", "**.h")),
			path.join(zlib_root, "**.h"),
			path.join(zlib_root, "*.c"),
		}

		removefiles {
			--path.join(zlib_root, ".c"),
			path.join(zlib_root, "**", "zconf.h"),
		}

	if _OPTIONS["zlib-with-assembly"] ~= nil then
		configuration { "x64" }
			files {
				path.join(zlib_root, "contrib", "amd64", "*.S"),
			}
		configuration { "not x64" }
			files {
				path.join(zlib_root, "contrib", "asm686", "*.S"),
			}
		configuration { "vs*" }
			defines {
				"ASMV",
				"ASMINF",
			}
			removefiles {
				path.join(zlib_root, "contrib", "**.S"),
			}
		configuration { "vs*", "x64" }
			files {
					path.join(zlib_root, "contrib", "masmx64", "*.c"),
				}
		configuration { "vs*", "not x64" }
			files {
					path.join(zlib_root, "contrib", "masmx86", "*.c"),
				}
		configuration { "osx" }
			files {
				path.join(zlib_root, "contrib", "masmx64", "*.c"),
			}

		configuration {}
	end -- zlib-with-assembly

	build_c89('z')

	----
	group "thirdparty"
	project "minizip"
		kind "StaticLib"
		language "C++"
		flags {}

		configuration {}

		includedirs {
			zlib_includedirs,
		}

		defines {
			"STDC",
		}

		files {
			path.join(zlib_root, "contrib", "minizip", "**.h"),
			path.join(zlib_root, "contrib", "minizip", "**.c"),
		}

		configuration { "not vs*" }
			removefiles {
				path.join(zlib_root, "contrib", "minizip", "iowin32.c"),
			}
		configuration {}
		build_c89('z')
	---

	----
	group "thirdparty"
	project "zfstream"
		kind "StaticLib"
		language "C++"
		flags {}

		configuration {}

		includedirs {
			zlib_includedirs,
		}

		files {
			path.join(zlib_root, "contrib", "iostream3", "zfstream.cc"),
		}
	---
	end, -- _create_projects()
}

---
