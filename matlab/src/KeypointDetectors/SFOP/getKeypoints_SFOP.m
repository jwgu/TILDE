function [keypts] = getKeypoints_SFOP(img_info, p)

    sfop_name = [img_info.full_feature_prefix '_SFOP_keypoints.mat'];
    if ~exist(sfop_name, 'file')

        in = img_info.image_name;
        out = [img_info.full_feature_prefix '_SFOP_keypointstxt'];
        sfop(in,out);

        [feat, ~, ~] = loadFeatures(out);
        feat = feat';
        score = load([out '.score']);

        % Get the scale 
        a = feat(3,:);
        b = feat(4,:);
        c = feat(5,:);
        % obtain scales
        scale = sqrt(a.*c - b.^2); % sqrt of determinant (sqrt of product of eigs)
        scale = 1./sqrt(scale); % inverse becuz it's actually inv of [a b; b c]

        keypts = [feat(1:2,:); zeros(5,size(feat,2))];
        keypts(5,:) = score';
        keypts(6,:) = scale';
        
        save(sfop_name, 'keypts', '-v7.3');
    else
        loadkey = load(sfop_name);
        keypts = loadkey.keypts;
    end
end