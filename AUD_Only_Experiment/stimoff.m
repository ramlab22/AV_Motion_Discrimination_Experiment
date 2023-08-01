function [] = stimoff(TDT)
TDT.write('aud_off',1); %aud_off - TRUE = 1 , FALSE = 0, Begin with aud_off = 0
TDT.halt();