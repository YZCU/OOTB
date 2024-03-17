function boxes = aff2image(aff_maps, T_sz)
r		= T_sz(1);
c		= T_sz(2);			% height and width of template
n		= size(aff_maps,2);	% number of affine results
boxes	= zeros(8,n);	
for ii=1:n
	aff	= aff_maps(:,ii);
	R	= [ aff(1), aff(2), aff(5);...
			aff(3), aff(4), aff(6)];
		
	P	= [	1, r, 1, r; ...
			1, 1, c, c; ...
			1, 1, 1, 1];

	Q	= R*P;
	boxes(:,ii)	= Q(:);
end
