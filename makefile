# author: khangpt

init:
	@echo "*** Automatically process cli ***";

# include makes/packages.makefile

# clean: cleanAll

# get: getAll

# gen: genAll

gen:
	@dart run build_runner build -d

run:
	@flutter run --debug -t lib/main.dart

# genAsset:
# 	@echo "👉 Running assets generating..."; \
# 	./gen_assets.sh; \
# 	echo "👉 Running assets generating for ticket_booking_package..."; \
# 	cd ./packages/ticket_booking_package/ && ./gen_assets.sh

# run:
# 	@if [ -n "$(env)" ]; then \
# 		echo "👉 Ready to run debug app for flavor:$(env)..."; \
# 		cd app/; \
# 		flutter run --debug -t lib/main.dart --flavor $(env) --dart-define BUILD_MODE=$(env); \
# 	else \
# 		echo "❌ Running exception..."; \
# 		echo "❌ Missing env param [dev, stg, uat, prod]..."; \
# 	fi

# runNoImpeller:
# 	@if [ -n "$(env)" ]; then \
# 		echo "👉 Ready to run debug app for flavor:$(env) without impeller-renderer-engine..."; \
# 		cd app/; \
# 		flutter run --debug -t lib/main.dart --flavor $(env) --dart-define BUILD_MODE=$(env) --no-enable-impeller; \
# 	else \
# 		echo "❌ Running exception..."; \
# 		echo "❌ Missing env param [dev, stg, uat, prod]..."; \
# 	fi


