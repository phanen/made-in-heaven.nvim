<img align="left" width=28% src=https://static.jojowiki.com/images/b/bb/latest/20211117220434/Made_in_Heaven_Infobox_Manga.png />

```lua
local mih = require('made-in-heaven')
local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.expr = true
  vim.keymap.set(mode, lhs, rhs, opts)
end
map('', 'h', mih.h)
map('', 'l', mih.l)
map('', 'j', mih.j)
map('', 'k', mih.k)
map('', 'w', mih.w)
map('', '<c-a>', mih['<c-a>'])
map('', '<c-d>', mih['<c-d>'])
map('', '<c-f>', mih['<c-f>'])
map('i', '<c-w>', mih['<c-w>'])
-- useless
map('n', '<c-n>', mih['<cmd>bn<cr>'])
map('n', '<c-p>', mih['<cmd>bp<cr>'])
-- placeholder
map('n', '<c-a>', mih['<cmd>echomsg 󱗃<cr>'])
```

## credit
* https://github.com/xiyaowong/fast-cursor-move.nvim
* https://github.com/tani/dmacro.vim
* https://jojowiki.com/Made_in_Heaven
