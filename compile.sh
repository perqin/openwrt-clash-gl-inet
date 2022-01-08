#!/bin/sh -e

dir="$(cd "$(dirname "$0")" ; pwd)"

package_name="clash"
golang_commit="eac2e91a285e9df119ce1aac0f4fe340cc54a6e4"

cd "$sdk_home_dir"

# replace golang with version defined in env
if [ -n "$golang_commit" ] ; then
	( test -d "feeds/packages/lang/golang" && \
		rm -rf "feeds/packages/lang/golang" ) || true

	curl "https://codeload.github.com/openwrt/packages/tar.gz/$golang_commit" | \
		tar -xz -C "feeds/packages/lang" --strip=2 "packages-$golang_commit/lang/golang"
fi

./scripts/feeds install -a

rm -rf "package/$package_name"
ln -sf "$dir" "package/$package_name"

make package/$package_name/clean
make package/$package_name/compile V=s

find "$sdk_home_dir/bin/" -type f -name "${package_name}*.ipk" -exec cp -f {} "$dir" \;
