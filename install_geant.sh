#/!bin/bash

# You can install reqd packages if you want... all installations will be local
if [ "$UID" -ne 0 ]; then
    echo "You are about to install locally..."
else
    sudo apt-get install git build-essential emacs gcc libhdf5-dev python-pip smartmontools cmake cmake-curses-gui libexpat1-dev libxmu-dev qt4-dev-tools openssh-server lm-sensors -y
fi

export geant="geant4.10.03.p01.tar.gz"
if ! [ -a "$geant" ]; then
    wget http://geant4.cern.ch/support/source/$geant
fi
if ! [ -d "geant" ]; then
    mkdir geant
    mkdir geant/build
fi
tar xvf $geant -C geant --strip-components=1
cd geant/build

export install_dir=$PWD
cmake -DXERCESC_LIBRARY='/home/nedc/Documents/Geant4/xercesc/lib' -DXERCESC_INCLUDE_DIR='/home/nedc/Documents/Geant4/xercesc/include' -DGEANT4_USE_GDML=ON -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=ON -DCMAKE_INSTALL_PREFIX=$install_dir ..
make -j8;
if [ "$UID" -eq 0 ]; then
    sudo make install;
else
    make install;
fi

echo ". $install_dir/bin/geant4.sh" >> ~/.bashrc