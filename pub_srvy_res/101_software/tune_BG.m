function tune_BG(dat,bg,cc)

for b = 1:length(dat)
    bg.CData(b,:) = cc(b,:)
end
end

