# ═══════════════════════════════════════════════════════════════════════════
# MAKEFILE - Test Automation Commands
# ═══════════════════════════════════════════════════════════════════════════
# Purpose: Provide consistent test commands for TDD workflow.
#
# Usage:
#   make test           Run all tests
#   make test-coverage  Run tests with coverage
#   make test-smoke     Run smoke tests only
#   make test-unit      Run unit tests only
#   make test-widget    Run widget tests only
#   make test-e2e       Run integration tests only
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: all test test-coverage test-smoke test-unit test-widget test-e2e clean help

# Default target
all: test

# ═══════════════════════════════════════════════════════════════════════════
# TEST COMMANDS
# ═══════════════════════════════════════════════════════════════════════════

## Run all tests
test:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🧪 Running All Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test

## Run tests with coverage report
test-coverage:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📊 Running Tests with Coverage"
	@echo "═══════════════════════════════════════════════════"
	flutter test --coverage
	@echo ""
	@echo "📈 Coverage report generated at: coverage/lcov.info"
	@echo "Run 'make coverage-html' to generate HTML report"

## Generate HTML coverage report
coverage-html: test-coverage
	@echo "═══════════════════════════════════════════════════"
	@echo "  🌐 Generating HTML Coverage Report"
	@echo "═══════════════════════════════════════════════════"
	genhtml coverage/lcov.info -o coverage/html
	@echo ""
	@echo "📊 Open coverage/html/index.html in browser"

## Run smoke tests only (fast sanity check)
test-smoke:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🚀 Running Smoke Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/smoke/

## Run security smoke tests
test-security:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🔒 Running Security Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/smoke/security_smoke_test.dart

## Run unit tests only
test-unit:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🔬 Running Unit Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/unit/

## Run widget tests only
test-widget:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📱 Running Widget Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/widget/

## Run integration tests only
test-e2e:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🔗 Running Integration Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/integration/

## Run page coverage tests
test-pages:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📄 Running Page Coverage Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/integration/page_coverage_test.dart

## Run screen widget tests
test-screens:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📺 Running Screen Widget Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test test/widget/screens/screen_widget_tests.dart

# ═══════════════════════════════════════════════════════════════════════════
# MOBILE DEVICE TESTS (Android/iOS)
# ═══════════════════════════════════════════════════════════════════════════

## Run integration tests on connected Android device
test-android:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🤖 Running Android Integration Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test integration_test/app_test.dart -d android

## Run integration tests on connected iOS device/simulator
test-ios:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🍎 Running iOS Integration Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test integration_test/app_test.dart -d ios

## Run integration tests on any connected device
test-device:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📱 Running Device Integration Tests"
	@echo "═══════════════════════════════════════════════════"
	flutter test integration_test/app_test.dart

## List connected devices
devices:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📲 Connected Devices"
	@echo "═══════════════════════════════════════════════════"
	flutter devices

# ═══════════════════════════════════════════════════════════════════════════
# TDD WORKFLOW
# ═══════════════════════════════════════════════════════════════════════════

## Watch for changes and re-run tests (requires entr)
test-watch:
	@echo "═══════════════════════════════════════════════════"
	@echo "  👀 Watching for changes..."
	@echo "═══════════════════════════════════════════════════"
	find lib test -name "*.dart" | entr -c flutter test

## Generate test stub for new screen
generate-screen-test:
	@echo "═══════════════════════════════════════════════════"
	@echo "  ✨ Screen Test Generator"
	@echo "═══════════════════════════════════════════════════"
	dart run tool/generate_screen_test.dart --help

# ═══════════════════════════════════════════════════════════════════════════
# BUILD & CLEAN
# ═══════════════════════════════════════════════════════════════════════════

## Clean build artifacts
clean:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🧹 Cleaning build artifacts"
	@echo "═══════════════════════════════════════════════════"
	flutter clean
	rm -rf coverage/

## Build code generation (Freezed, etc.)
build-runner:
	@echo "═══════════════════════════════════════════════════"
	@echo "  ⚙️ Running build_runner"
	@echo "═══════════════════════════════════════════════════"
	dart run build_runner build --delete-conflicting-outputs

## Full rebuild with tests
rebuild: clean build-runner test
	@echo "═══════════════════════════════════════════════════"
	@echo "  ✅ Rebuild complete!"
	@echo "═══════════════════════════════════════════════════"

# ═══════════════════════════════════════════════════════════════════════════
# HELP
# ═══════════════════════════════════════════════════════════════════════════

## Show help
help:
	@echo "═══════════════════════════════════════════════════"
	@echo "  📚 Available Commands"
	@echo "═══════════════════════════════════════════════════"
	@echo ""
	@echo "  Test Commands:"
	@echo "    make test           Run all tests"
	@echo "    make test-coverage  Run with coverage"
	@echo "    make test-smoke     Smoke tests only"
	@echo "    make test-security  Security tests only"
	@echo "    make test-unit      Unit tests only"
	@echo "    make test-widget    Widget tests only"
	@echo "    make test-e2e       Integration tests only"
	@echo "    make test-pages     Page coverage tests"
	@echo "    make test-screens   Screen widget tests"
	@echo ""
	@echo "  TDD Workflow:"
	@echo "    make test-watch     Watch & re-run tests"
	@echo "    make generate-screen-test  Generate test stub"
	@echo ""
	@echo "  Build:"
	@echo "    make clean          Clean artifacts"
	@echo "    make build-runner   Run code generation"
	@echo "    make rebuild        Full rebuild with tests"
	@echo ""
	@echo "  Coverage:"
	@echo "    make coverage-html  Generate HTML report"
	@echo ""
