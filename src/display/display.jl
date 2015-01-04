export pin, unpin

type WebView
  last
  pinned
end

pinned(view::WebView) =
  isa(view.pinned, Window) && active(view.pinned) ? view.pinned : nothing

WebView() = WebView(nothing, nothing)

const _display = WebView()
view() = _display

function init()
#   shell()
  setdisplay(Media.Graphical, view())
end

displaysize(x) = (500, 400)
displaytitle(x) = "Julia"

function Graphics.render(view::WebView, x; options = @d())
  size = displaysize(x)
  html = tohtml(x)
  w = isa(pinned(view), Window) ? view.pinned :
        window(@d(:width => size[1], :height => size[2]))
  loadhtml(w, html)
  title(w, string(displaytitle(x), " (", id(w), ")",
                  isa(pinned(view), Window) ? pinstr : ""))
  view.last = w
  return w
end

# Pin / unpin API

const pinstr = "*"

pintitle(w) = active(w) && title(w, string(title(w), pinstr))
unpintitle(w) = active(w) && title(w, replace(title(w), pinstr, ""))

pintitle(::Nothing) = nothing
unpintitle(::Nothing) = nothing

function pin(w::Window)
  unpin()
  view().pinned = pintitle(w)
end

pin(id) = pin(Window(id, shell()))
pin() = pin(view().last)

function pin(::Nothing)
  unpintitle(view().pinned)
  view().pinned = nothing
end

unpin() = pin(nothing)
