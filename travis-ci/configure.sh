#!/usr/bin/env sh

# Exit on errors
set -e

cd "${TRAVIS_BUILD_DIR}"

. travis-ci/defs.sh

print_headline "Configuring for building for ${QT} on ${TRAVIS_OS_NAME}"

if [ "${QT}" = "qt5" ]; then
	qmake texstudio.pro CONFIG+=debug
  	sh -e /etc/init.d/xvfb start
	sleep 3
elif [ $QT = qt5NoPoppler ]; then
	qmake texstudio.pro CONFIG+=debug NO_POPPLER_PREVIEW=1
elif [ $QT = qt4 ]; then
	qmake texstudio.pro CONFIG+=debug
elif [ $QT = qt5win ]; then
	print_info "Running CMake"
	echo_and_run "${MXEDIR}/usr/bin/${MXETARGET}-cmake .. \
		-DCMAKE_BUILD_TYPE='Release' \
		-DTW_BUILD_ID='travis-ci' \
		-DDESIRED_QT_VERSION=${QT} \
		-DQTPDF_ADDITIONAL_LIBS='freetype;harfbuzz;freetype;glib-2.0;intl;iconv;ws2_32;winmm;tiff;jpeg;png;lcms2;lzma;bz2' \
		-DTEXWORKS_ADDITIONAL_LIBS='pcre16;opengl32;imm32;shlwapi;dwmapi;uxtheme' \
		-Dgp_tool='none'"
elif [ "${TRAVIS_OS_NAME}" = "osx" ]; then
	/usr/local/opt/qt/bin/qmake texstudio.pro CONFIG-=debug
fi

cd "${TRAVIS_BUILD_DIR}"

print_info "Successfully configured build"

