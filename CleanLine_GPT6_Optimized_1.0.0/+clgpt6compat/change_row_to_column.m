function data = change_row_to_column(data)
%CHANGE_ROW_TO_COLUMN Put a vector on the sample axis.
% Independent compatibility implementation for CleanLine V2 numeric data.
if isstruct(data)
    if numel(data)==1
        names=fieldnames(data);
        data=data.(names{1});
        data=data(:);
    end
elseif isvector(data)
    data=data(:);
end
end
