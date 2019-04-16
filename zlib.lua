-- scaffold geniefile for zlib

zlib_script = path.getabsolute(path.getdirectory(_SCRIPT))
zlib_root = path.join(zlib_script, "zlib")

zlib_includedirs = {
	path.join(zlib_script, "config"),
	zlib_root,
}

zlib_libdirs = {}
zlib_links = {}
zlib_defines = {}

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
		links { "zlib" }
	end,

	_create_projects = function()

project "zlib"
	kind "StaticLib"
	language "C++"
	flags {}

	includedirs {
		zlib_includedirs,
	}

	defines {}

	files {
		path.join(zlib_script, "config", "**.h"),
		path.join(zlib_root, "**.h"),
		path.join(zlib_root, "**.cpp"),
	}

end, -- _create_projects()
}

---
