" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
" Yank to system clipboard
set clipboard=unnamed

" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands
exmap togglefold obcommand editor:toggle-fold
exmap foldmore obcommand editor:fold-more
exmap foldless obcommand editor:fold-less
nmap zo :foldless
nmap zc :foldmore
nmap za :togglefold

exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

exmap foldall obcommand editor:fold-all
nmap zM :foldall

unmap <Space>
exmap vsp obcommand workspace:split-vertical
nmap <Space>v :vsp

exmap workspaceclose obcommand workspace:close
nmap <Space>q :workspaceclose

exmap switcheropen obcommand switcher:open
nmap <Space>f :switcheropen 

exmap appreload obcommand app:reload
nmap <Space>es :appreload
