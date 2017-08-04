#/!bin/bash

# Install required packages if you want. All installations will be local.
if [ "$UID" -ne 0 ]; then
  echo "You are about to install locally..."
else
  sudo apt-get install git build-essential emacs gcc libhdf5-dev python-pip smartmontools cmake cmake-curses-gui libexpat1-dev libxmu-dev qt4-dev-tools openssh-server lm-sensors -y
fi

# Set the name of the compressed file for the Xerces-C source code download.
#
# Note: The exact name needs periodic updating by the maintainer of this code!
export xercesc="xerces-c-3.1.4.tar.gz"

# If the '-a' flag is not set as an argument to this script, then download the
#   source code.
if ! [ -a "$xercesc" ]; then
  wget http://www-us.apache.org/dist//xerces/c/3/sources/$xercesc
fi

if ! [ -d "xercesc" ]; then
  mkdir xercesc;
fi

tar xvf $xercesc -C xercesc --strip-components=1

cd xercesc

if [ "$UID" -eq 0 ]; then
  sudo ./configure;
  sudo make;
  sudo make install;
else
  ./configure;
  make;
  make install;
fi

cd ..

export geant="geant4.10.03.p02.tar.gz"

if ! [ -a "$geant" ]; then
  wget http://geant4.cern.ch/support/source/$geant
fi

if ! [ -d "geant" ]; then
  mkdir geant;
  mkdir geant/source;
  mkdir geant/build;
fi


# tar xvf $geant -C geant --strip-components=1

tar xvf $geant -C geant/source --strip-components=1

cd geant/build

export xerces_dir="../../xercesc"
export install_dir="$PWD"
export source_dir="../source"
# cmake -DXERCESC_LIBRARY="$install_dir/xercesc/lib" -DXERCESC_INCLUDE_DIR="$install_dir/xercesc/include" -DGEANT4_USE_GDML=ON -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=ON -DCMAKE_INSTALL_PREFIX=$install_dir ..

if [ "$UID" -eq 0 ]; then
  sudo cmake -DXERCESC_ROOT_DIR=$xerces_dir -DGEANT4_USE_GDML=ON -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=ON -DCMAKE_INSTALL_PREFIX=$install_dir $source_dir;
  sudo make -j8;
  sudo make install;
else
  cmake -DXERCESC_ROOT_DIR=$xerces_dir -DGEANT4_USE_GDML=ON -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=ON -DCMAKE_INSTALL_PREFIX=$install_dir $source_dir;
  make -j8;
  make install;
fi

cd ../..

rm $xercesc

rm $geant

# echo ". $install_dir/bin/geant4.sh" >> ~/.bashrc
