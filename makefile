# author: khangpt

init:
	@echo "*** Automatically process cli ***";

get:
	@flutter pub get

gen:
	@dart run build_runner build -d

run:
	@flutter run --debug -t lib/main.dart

