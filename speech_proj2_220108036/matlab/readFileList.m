function [files, labels] = readFileList(listFile)

fid = fopen(listFile, 'r');
assert(fid ~= -1, 'Cannot open list file: %s', listFile);

files = {};
labels = [];

% Folder where the list file is located
[listDir, ~, ~] = fileparts(which(listFile));
if isempty(listDir)
    [listDir, ~, ~] = fileparts(listFile);
end

cleanup = onCleanup(@() fclose(fid));

while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line) || startsWith(line, '#')
        continue;
    end

    parts = strsplit(line);
    assert(numel(parts) >= 2, 'Each line must contain file path and label.');

    relPath = parts{1};
    lab = str2double(parts{2});

    % If path is not absolute, make it relative to the list file location
    if ispc
        isAbs = contains(relPath, ':\') || startsWith(relPath, '\\');
    else
        isAbs = startsWith(relPath, '/');
    end

    if isAbs
        absPath = relPath;
    else
        absPath = fullfile(listDir, relPath);
    end

    files{end+1,1} = absPath; %#ok<AGROW>
    labels(end+1,1) = lab; %#ok<AGROW>
end

end