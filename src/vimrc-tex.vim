" Compile tex file to dvi
nmap <F5> :wall<CR>:! latex % && evince %:r.dvi<CR><CR>

" Compile tex file to pdf
nmap <F9> :wall<CR>:! dvips %:r.dvi && ps2pdf %:r.ps %:r.pdf && evince %:r.pdf
