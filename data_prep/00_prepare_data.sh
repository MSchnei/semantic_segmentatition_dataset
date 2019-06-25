# Specify parent path
parent_path="/media/sf_D_DRIVE/Unet"
export parent_path

# Create folder for training data
mkdir -p ${parent_path}/data

# Download the training data
wget -P ${parent_path}/data/ "https://zenodo.org/record/1206163/files/shared_data.zip"

# Unzip the downloaded folders
unzip ${parent_path}/data/shared_data.zip -d ${parent_path}/data/

# Remove zipped folders
rm -rf ${parent_path}/data/shared_data.zip
