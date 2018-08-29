% Using Matlab R2016b

% (a) Reading the Training Images:

clear;
Num_Of_Samples = 20;
Image_Height = 72;
Image_Width = 64;
train_Path = 'PCA_Images\Training\';
for i = 1: Num_Of_Samples
    str_Load = strcat(train_Path, num2str(i), '.bmp');
    Image = imread(str_Load);
    Training_Image(:,i) = double(reshape(Image, [ ], 1));
end

disp(['The dimension of TrainingImage is ',num2str(size(Training_Image))]);


% (b) Calculating the Mean Face and the Demeaned Faces:

Mean_Face = zeros(length(Training_Image),1);
for i = 1: Num_Of_Samples
    Mean_Face = Mean_Face+Training_Image(:,i);
end
Mean_Face = Mean_Face/Num_Of_Samples;

for i = 1: Num_Of_Samples
    Demean_Face(:,i) = Training_Image(:,i) - Mean_Face;
end

Show_Mean_Face = reshape(Mean_Face, [Image_Height,Image_Width]);
figure, imagesc(Show_Mean_Face), colorbar, colormap(gray), title('Mean Face')
saveas(gcf, 'Mean_Face', 'jpeg')

for i = 1: Num_Of_Samples
    Display = Demean_Face(:,i);
    Display = reshape(Display, [Image_Height Image_Width]);
    figure, imagesc(Display), colorbar, colormap(gray), title(['Demeaned Face',num2str(i)])
    name = ['Demean_Face',num2str(i)];
    saveas(gcf, name, 'jpeg');
end


% (c) Computing the Eigenvalues and Eigenvectors/Eigenfaces:

CovFace1 = Demean_Face*Demean_Face';
disp(['The dimension of CovFace1 is ',num2str(size(CovFace1))]);
[EV1, ED1] = eig(CovFace1);

Cov_Face = Demean_Face'*Demean_Face;
[EV, ED] = eig(Cov_Face);
EV = Demean_Face*EV;
ED = sum(ED);
EV = EV ./ (ones(size(EV, 1),1) * sqrt(ED));
Temp = EV;
for i = 1:Num_Of_Samples
    EV(:,i) = Temp(:, Num_Of_Samples + 1 - i);
end
Temp = ED;
for i = 1:Num_Of_Samples
    ED(i) = Temp(Num_Of_Samples + 1 - i);
end

for i = 1: Num_Of_Samples-1
    Display = EV(:,i);
    Display = reshape(Display, [Image_Height Image_Width]);
    figure, imagesc(Display), colorbar, colormap(gray), title(['Eigenface',num2str(i)])
    name = ['Eigenface_',num2str(i)];
    saveas(gcf, name, 'jpeg');
end


% (d) Image Representation using Eigenfaces:

test_Path = 'PCA_Images\Testing\';
for i = 1: 4
    str_Load = strcat(test_Path, num2str(i), '.bmp');
    Image = imread(str_Load);
    Testing_Image(:,i) = double(reshape(Image, [ ], 1));
    TDemean_Face(:,i) = Testing_Image(:,i) - Mean_Face;
end

% Take Training Image 1 as an example, taking M = 4,8,12,15,19
figure, imagesc(reshape(Training_Image(:,1), [72 64])), colorbar, colormap(gray), title('Original Training Image 1')
for M = [4,8,12,15,19]
    Reconst(0,Demean_Face,TDemean_Face,1,EV,M,Mean_Face,Training_Image,Testing_Image);
end

% Reconstruction of testing images
test_Path = 'PCA_Images\Testing\';
for i = 1: 4
    str_Load = strcat(test_Path, num2str(i), '.bmp');
    Image = imread(str_Load);
    Testing_Image(:,i) = double(reshape(Image, [ ], 1));
    TDemean_Face(:,i) = Testing_Image(:,i) - Mean_Face;
    Reconst(1,Demean_Face,TDemean_Face,i,EV,19,Mean_Face,Training_Image,Testing_Image);
end


% (e) Face Recognition using Eigenfaces:

for i = 1:20
    MCoeff(:,i) = Demean_Face(:,i)'*EV;
end
MCoeff = MCoeff';

for i = 1:2
    TCoeff(:,i) = TDemean_Face(:,i)'*EV;
end
TCoeff = TCoeff';

% Recognition of Testing Image 1:
Recogn(1,TCoeff,MCoeff,Testing_Image,Training_Image)

% Recognition of Testing Image 2:
Recogn(2,TCoeff,MCoeff,Testing_Image,Training_Image)



function Reconst(dataset_num,Demean_Face,TDemean_Face,i,EV,M,MeanFace,Training_Image,Testing_Image,ED)
if dataset_num == 0
    dataset = Demean_Face;
    name = 'Training Image';
    origin = Training_Image;
else
    dataset = TDemean_Face;
    name = 'Testing Image';
    origin = Testing_Image;
end
for j = 1:20
    coef(j) = dataset(:,i)'*EV(:,j);
end
ReconstImage = zeros(4608,1);
for j = 1:M
    ReconstImage = ReconstImage+coef(j)*EV(:,j);
end
ReconstImage = MeanFace + ReconstImage;
Display = reshape(ReconstImage, [72 64]);
figure, imagesc(Display), colorbar, colormap(gray), title(['Reconstructed ', name, num2str(i),', M=',num2str(M)])
saveas(gcf, ['Reconstructed_',name,num2str(i),'_M=',num2str(M)], 'jpeg');
Difference = origin(:,i) - ReconstImage;
SSE = sum(sum(Difference.*Difference));
disp(['When M=', num2str(M), ', the sum of squared error of reconstructed ', name, num2str(i), ' is ', num2str(SSE)]);
end

function Recogn(i,TCoeff,MCoeff,Testing_Image,Training_Image)
for j = 1:20
    Temp = TCoeff(i,:) - MCoeff(j,:);
    Temp = sum(Temp.*Temp);
    Eu_Distance(j) = sqrt(Temp);
end
[~,index]=sort(Eu_Distance);
disp(['The three closest images to testing image ', num2str(i),' are training image ', num2str(index(1:3))]);
figure, imagesc(reshape(Testing_Image(:,i), [72 64])), colormap(gray), title(['Testing Image ', num2str(i)])
for j = 1:3
    figure, imagesc(reshape(Training_Image(:,index(j)), [72 64])), colormap(gray), title(['Training Image ', num2str(index(j))])
end
end
