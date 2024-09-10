function [slope,sigma_scaled,coherence_low,coherence_high] = calculate_slope_dynamic_range(params)
    % calculate_slope_dynamic_range: Computes the slope and dynamic range parameters.
    %
    % Usage:
    %   [slope, sigma_scaled, coherence_low, coherence_high] = calculate_slope_dynamic_range(params)
    %
    % Description:
    %   Given the parameters of a fitted psychometric function, this function
    %   calculates the slope and dynamic range for a
    %   psychometric function based on given parameters. The slope is computed
    %   between two points of coherence corresponding to specified CDF values. 
    %   The standard deviation (sigma) parameter is scaled by the difference in
    %   lapse rate parameters (b(4) - b(3)).
    %
    % Inputs:
    %   params - A 1x4 vector containing the fitted parameters of the psychometric function:
    %       b(1) = mu           (mean of the Gaussian)
    %       b(2) = sigma        (standard deviation of the Gaussian)
    %       b(3) = floor_value  (minimum lapse rate)
    %       b(4) = ceiling_value (maximum lapse rate)
    %
    % Outputs:
    %   slope - The slope of the psychometric function between the 10% and 90% saturation points.
    %   sigma_scaled - The scaled standard deviation of the Gaussian.
    %   coherence_low - The coherence value corresponding to the low saturation point 
    %   coherence_high - The coherence value corresponding to the high saturation point 
    %
    % Example:
    %   params = [0, 1, 0.1, 0.9];
    %   [slope, sigma_scaled, coherence_low, coherence_high] = calculate_slope_dynamic_range(params)
    %
    % Notes:
    %   If the difference between lapse_ceiling and lapse_floor is less than 0.4,
    %   the low and high saturation values are set to 0.0001 and 0.999, respectively.
    %   Otherwise, they are set to 0.10 and 0.90.
    %
    % See also: lsqcurvefit, erf, erfinv
    
    % Extract parameters
    mu = params(1);
    sigma = params(2);
    lapse_floor = params(3);
    lapse_ceiling = params(4);
    
    % Scale the standard deviation (sigma) by the difference in lapse rates
    sigma_scaled = sigma * (lapse_ceiling - lapse_floor);
    
  
    low_saturation_val=0.10;
    high_saturation_val=0.90;
    % % Calculate the low and high saturation points
     cdf_low = lapse_floor + (lapse_ceiling - lapse_floor) * low_saturation_val;
     cdf_high = lapse_floor + (lapse_ceiling - lapse_floor) * high_saturation_val;
     
   
    % Inverse CDF to find the corresponding x values (10% and 90% for most functions)
    coherence_low = mu + sigma * sqrt(2) * erfinv(2 * (cdf_low - lapse_floor) / (lapse_ceiling - lapse_floor) - 1);
    coherence_high = mu + sigma * sqrt(2) * erfinv(2 * (cdf_high - lapse_floor) / (lapse_ceiling - lapse_floor) - 1);
 % coherence_low = mu + sigma_scaled * sqrt(2) * erfinv(2 * (cdf_low - lapse_floor) / (lapse_ceiling - lapse_floor) - 1);
    %coherence_high = mu + sigma_scaled * sqrt(2) * erfinv(2 * (cdf_high - lapse_floor) / (lapse_ceiling - lapse_floor) - 1);

    % Calculate the slope
    slope = (cdf_high - cdf_low) / (coherence_high - coherence_low);
    
    if coherence_low==coherence_high || slope>10
        coherence_low=NaN;
        coherence_high=NaN;
        slope=NaN;
    end
end
