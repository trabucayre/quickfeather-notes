export INSTALL_DIR=/home/toolchains/quicklogic
BIN_DIR=$INSTALL_DIR/bin
export YOSYS=$BIN_DIR/yosys
export PATH=$BIN_DIR:$PATH

NPROC=$(nproc)

SKIP_VPR=0
SKIP_YOSYS=0
SKIP_PLUGINS=0
SKIP_SYMBIFLOW=0

if [ ! $SKIP_YOSYS == 1 ]; then
	#Checkout *yosys* repository (https://github.com/QuickLogic-Corp/yosys.git), branch: **quicklogic-rebased**. 
	[ -e quicklogic-yosys ] || git clone https://github.com/QuickLogic-Corp/yosys.git -b quicklogic-rebased quicklogic-yosys
	cd quicklogic-yosys
	make -j8 config-gcc 2>&1 > ../yosys-config-gcc.log # for compiling using gcc
	make -j8 install PREFIX=$INSTALL_DIR 2>&1 > ../yosys-install.log
	cd -
fi

if [ ! $SKIP_VPR == 1 ]; then
	[ -e vtr-verilog-to-routing ] || git clone https://github.com/QuickLogic-Corp/vtr-verilog-to-routing.git
	mkdir vtr-verilog-to-routing/build
	cd vtr-verilog-to-routing/build
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../
	make -j$NPROC && make -j$NPROC install
	cd -
fi

if [ ! $SKIP_PLUGINS == 1 ]; then
	#Checkout *yosys-symbiflow-plugins* (https://github.com/QuickLogic-Corp/yosys-symbiflow-plugins), branch: **ql-ios**.
	[ -e yosys-symbiflow-plugins ] || git clone https://github.com/QuickLogic-Corp/yosys-symbiflow-plugins -b ql-ios
	cd yosys-symbiflow-plugins
	#export PATH='specify Yosys installation path as specified in PREFIX in previous step':$PATH
	make -j8 > ../yosys-symbiflow-plugins-build.log 2>&1
	make -j8 install > ../yosys-symbiflow-plugins-install.log 2>&1
	cd -
fi

if [ ! $SKIP_SYMBIFLOW == 1 ]; then
	DIR=symbiflow-arch-defs
	#Checkout *symbiflow-arch-defs* repository https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git), branch: **quicklogic-upstream-rebase**. 
	if [ ! -e symbiflow-arch-defs ]; then
		git clone https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git -b quicklogic-upstream-rebase
		cd $DIR
		sed -i -- 's,\$(CMAKE_COMMAND) \${CMAKE_FLAGS} ..,\$(CMAKE_COMMAND) -DCMAKE_INSTALL_PREFIX=\$(PREFIX) \${CMAKE_FLAGS} ..,g' Makefile
		#sed -i -- 's,-m pip install,-m pip --user install,g' common/cmake/env.cmake
		cd -
	fi
#	#export YOSYS='path to Yosys binary, installed in first step'
	cd symbiflow-arch-defs
	echo "$DIR: make env"
	make -j8 PREFIX=$INSTALL_DIR env > ../build-$DIR.log 2>&1
	cd build
	echo "$DIR: make all_conda"
	make -j8 all_conda > ../../build-$DIR-conda.log 2>&1
	cd quicklogic
#	## marche pas
#	#echo "$DIR: make techmap"
#	#make -j8 file_build_quicklogic_techmap_cells_sim.v > ../../../build-$DIR-techmap.log 2>&1
#	echo "$DIR: make install"
#	make -j8 PREFIX=$INSTALL_DIR install > ../../../build-$DIR-install.log 2>&1
	#cd build/quicklogic
	make file_build_quicklogic_pp3_techmap_cells_sim.v
	cd pp3
	make quickfeather
	make install PREFIX=$INSTALL_DIR
	#make PREFIX=$INSTALL_DIR DEVICE_INSTALL_file_build_env_conda_bin_qlfasm
	# not sure maybe useless
	cd ../../vpr
	make install PREFIX=$INSTALL_DIR
	cd ../../../
fi

#Run any test case in the current terminal window. For example, follow these steps to run a test case:
# cd pp3/tests/quicklogic_testsuite/bin2seven
# make bin2seven-ql-chandalar_fasm
