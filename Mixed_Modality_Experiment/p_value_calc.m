function [p_values, bootstat] = p_value_calc(yData, parms)
    % p value calculations from here 
    % https://www.bmj.com/content/343/bmj.d2304
    
    %Bootstrap y data(% correct values)
    % get CI values for each of the coeffs. 
    % SE - standard error
    % z - test statistic
    
    
    [ci,bootstat] = bootci(100,@(x)[mean(x) std(x)],yData);
    SE = (ci(2,:) - ci(1,:))./(2*1.96);
    z = parms./SE;
    p_values = exp(-0.717.*z - 0.416.*z.^2);
    end