export INSTALL_DIR=${INSTALL_DIR:-$(pwd)/quicklogic}
BIN_DIR=$INSTALL_DIR/bin
export YOSYS=$BIN_DIR/yosys
export GENFASM=$BIN_DIR
export PATH=$BIN_DIR:$HOME/.local/bin:$PATH

NPROC=$(nproc)

SKIP_VPR=${SKIP_VPR:-0}
SKIP_YOSYS=${SKIP_YOSYS:-0}
SKIP_PLUGINS=${SKIP_PLUGINS:-0}
SKIP_SYMBIFLOW=${SKIP_SYMBIFLOW:-0}

# prepare build directory
[ -e build ] || mkdir build

pushd build

if [ ! $SKIP_YOSYS == 1 ]; then
	#Checkout *yosys* repository (https://github.com/QuickLogic-Corp/yosys.git), branch: **quicklogic-rebased**. 
	[ -e quicklogic-yosys ] || git clone https://github.com/QuickLogic-Corp/yosys.git -b quicklogic-rebased quicklogic-yosys
# hash: 7ea257adc6ecbefa3bba368ad2bfc45100351778
	cd quicklogic-yosys
	make -j$NPROC config-gcc 2>&1 > ../yosys-config-gcc.log # for compiling using gcc
	make -j$NPROC install PREFIX=$INSTALL_DIR 2>&1 > ../yosys-install.log
	cd -
fi

if [ ! $SKIP_VPR == 1 ]; then
	[ -e vtr-verilog-to-routing ] || git clone https://github.com/QuickLogic-Corp/vtr-verilog-to-routing.git -b blackbox_timing
#hash 8980e46218542888fac879961b13aa7b0fba8432
	mkdir vtr-verilog-to-routing/build
	cd vtr-verilog-to-routing/build
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../
	make -j$NPROC && make -j$NPROC install
	cd -
fi

if [ ! $SKIP_PLUGINS == 1 ]; then
	#Checkout *yosys-symbiflow-plugins* (https://github.com/QuickLogic-Corp/yosys-symbiflow-plugins), branch: **ql-ios**.
	[ -e yosys-symbiflow-plugins ] || git clone https://github.com/QuickLogic-Corp/yosys-symbiflow-plugins -b ql-ios
#hash 6bbbc9b2698128ea68cdd6a4055f215db89b0e7a
	cd yosys-symbiflow-plugins
	#export PATH='specify Yosys installation path as specified in PREFIX in previous step':$PATH
	make -j$NPROC > ../yosys-symbiflow-plugins-build.log 2>&1
	make -j$NPROC install > ../yosys-symbiflow-plugins-install.log 2>&1
	cd -
fi

if [ ! $SKIP_SYMBIFLOW == 1 ]; then
	DIR=symbiflow-arch-defs
	#Checkout *symbiflow-arch-defs* repository https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git), branch: **quicklogic-upstream-rebase**. 
	if [ ! -e symbiflow-arch-defs ]; then
		#git clone https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git -b quicklogic-upstream-rebase
		git clone https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git
		cd $DIR
		git checkout ee84fa3840e8149ff3b6b30410272e224d1dd7a8
		# git checkout 02873668400bfadb88bac312fd3304b8b3876162 not working
		sed -i -- 's,\$(CMAKE_COMMAND) \${CMAKE_FLAGS} ..,\$(CMAKE_COMMAND) -DCMAKE_INSTALL_PREFIX=\$(PREFIX) \${CMAKE_FLAGS} ..,g' Makefile
		#sed -i -- 's,-m pip install,-m pip --user install,g' common/cmake/env.cmake
		cd -
	fi

	cd symbiflow-arch-defs
	echo "$DIR: make env"
	make -j$NPROC PREFIX=$INSTALL_DIR env > ../build-$DIR.log 2>&1
	cd build
	echo "$DIR: make all_conda"
	make -j$NPROC all_conda > ../../build-$DIR-conda.log 2>&1
	# build and install quicklogic
	cd quicklogic
	make install PREFIX=$INSTALL_DIR
	cd ../vpr
	make install PREFIX=$INSTALL_DIR
	cd ../../../

	# fix wrong env path
	sed -i "s,$(pwd)/$DIR/build/env/conda/bin/python3,/usr/bin/env python3,g" \
		$BIN_DIR/python/qlfasm
fi

#Run any test case in the current terminal window. For example, follow these steps to run a test case:
# cd pp3/tests/quicklogic_testsuite/bin2seven
# make bin2seven-ql-chandalar_fasm

popd
