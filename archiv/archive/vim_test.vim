" 将当前行的文本复制到剪贴板
function! CopyLineToClipboard()
  let line_text = getline('.')
  let @+ = line_text
  echo "Copied line: " . line_text
endfunction

" 绑定快捷键
map <leader>y :call CopyLineToClipboard()<CR>