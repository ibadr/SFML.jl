@enum(WindowStyle, 
window_none = 0, 
window_titlebar = 1 << 0, 
window_resize = 1 << 1, 
window_close = 1 << 2, 
window_fullscreen = 1 << 3, 
window_defaultstyle = (1 << 0) | (1 << 1) | (1 << 2))

type ContextSettings
	depth_bits::Uint32
	stencil_bits::Uint32
	antialiasing_level::Uint32
	major_version::Uint32
	minor_version::Uint32
	attribute_flags::Uint32

	function ContextSettings(depth_bits::Integer, stencil_bits::Integer, antialiasing_level::Integer, major_version::Integer, minor_version::Integer)
		new(depth_bits, stencil_bits, antialiasing_level, major_version, minor_version, 0)
	end
	function ContextSettings()
		new(0, 0, 0, 2, 2, 0)
	end
end

type RenderWindow
	ptr::Ptr{Void}
end

function RenderWindow(mode::VideoMode, title::String, settings::ContextSettings, style::WindowStyle...)
	style_int = 0
	for i = 1:length(style)
		style_int |= Int(style[i])
	end
	settings_ptr = pointer_from_objref(settings)
	return RenderWindow(ccall(dlsym(libcsfml_graphics, :sfRenderWindow_create), Ptr{Void}, (VideoMode, Ptr{Cchar}, Uint32, Ptr{Void},), mode, pointer(title), style_int, settings_ptr))
end

function RenderWindow(mode::VideoMode, title::String, style::WindowStyle...)
	return RenderWindow(mode, title, ContextSettings(), style[1])
end

function RenderWindow(title::String, width::Integer, height::Integer)
	mode = VideoMode(width, height)
	return RenderWindow(mode, title, window_defaultstyle)
end

function set_framerate_limit(window::RenderWindow, limit::Integer)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_setFramerateLimit), Void, (Ptr{Void}, Uint,), window.ptr, limit)
end

function set_vsync_enabled(window::RenderWindow, enabled::Bool)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_setVerticalSyncEnabled), Void, (Ptr{Void}, Int32,), window.ptr, enabled)
end

function isopen(window::RenderWindow)
	return ccall(dlsym(libcsfml_graphics, :sfRenderWindow_isOpen), Int32, (Ptr{Void},), window.ptr) == 1
end

function pollevent(window::RenderWindow, event::Event)
	return Bool(ccall(dlsym(libcsfml_graphics, :sfRenderWindow_pollEvent), Int32, (Ptr{Void}, Ptr{Void},), window.ptr, event.ptr))
end

function set_view(window::RenderWindow, view::View)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_setView), Void, (Ptr{Void}, Ptr{Void},), window.ptr, view.ptr)
end

function get_view(window::RenderWindow)
	return View(ccall(dlsym(libcsfml_graphics, :sfRenderWindow_getView), Ptr{Void}, (Ptr{Void},), window.ptr))
end

function get_default_view(window::RenderWindow)
	return View(ccall(dlsym(libcsfml_graphics, :sfRenderWindow_getDefaultView), Ptr{Void}, (Ptr{Void},), window.ptr))
end

function draw(window::RenderWindow, object::CircleShape)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_drawCircleShape), Void, (Ptr{Void}, Ptr{Void}, Ptr{Void},), window.ptr, object.ptr, C_NULL)
end

function draw(window::RenderWindow, object::RectangleShape)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_drawRectangleShape), Void, (Ptr{Void}, Ptr{Void}, Ptr{Void},), window.ptr, object.ptr, C_NULL)
end

function draw(window::RenderWindow, object::Sprite)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_drawSprite), Void, (Ptr{Void}, Ptr{Void}, Ptr{Void},), window.ptr, object.ptr, C_NULL)
end

function draw(window::RenderWindow, object::Text)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_drawText), Void, (Ptr{Void}, Ptr{Void}, Ptr{Void},), window.ptr, object.ptr, C_NULL)
end

function draw(window::RenderWindow, object::ConvexShape)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_drawConvexShape), Void, (Ptr{Void}, Ptr{Void}, Ptr{Void},), window.ptr, object.ptr, C_NULL)
end

function draw(window::RenderWindow, object::Line)
	draw(window, object.rect)
end

function clear(window::RenderWindow, color::Color)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_clear), Void, (Ptr{Void}, Color,), window.ptr, color)
end

function display(window::RenderWindow)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_display), Void, (Ptr{Void},), window.ptr)
end

function close(window::RenderWindow)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_close), Void, (Ptr{Void},), window.ptr)
end

function destroy(window::RenderWindow)
	ccall(dlsym(libcsfml_graphics, :sfRenderWindow_destroy), Void, (Ptr{Void},), window.ptr)
	window = nothing
end

function capture(window::RenderWindow)
	return Image(ccall(dlsym(libcsfml_graphics, :sfRenderWindow_capture), Ptr{Void}, (Ptr{Void},), window.ptr))
end

export RenderWindow, set_framerate_limit, isopen, pollevent, draw, clear, display, close, destroy, set_vsync_enabled, 
capture, ContextSettings, WindowStyle, window_none, window_resize, window_defaultstyle, window_close, window_fullscreen,
set_view, get_view, get_default_view, ContextSettings
