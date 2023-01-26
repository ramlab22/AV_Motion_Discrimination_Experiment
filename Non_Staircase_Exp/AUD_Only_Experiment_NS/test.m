[cnt, uniq] = hist(cell2mat(Right_dataout(1:end,8)), unique(cell2mat(Right_dataout(1:end,8))));
ii = [uniq';cnt];

audInfo.cohFreq_right = [audInfo.coherences;
                            zeros(1,length(audInfo.coherences))];
for i = 1:length(audInfo.coherences)
    for j = 1:length(ii)
        if ii(1,j) == audInfo.cohFreq_right(1,i)
            audInfo.cohFreq_right(2,i) = ii(2,j);
            break
        else
            audInfo.cohFreq_right(2,i) = 0;
        end
    end

end
  