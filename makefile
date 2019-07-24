
## Constants ##
#
XCODE_VERSION=10.2.1



## Macros ##
#
carthage = \
  carthage $(1) \
   --platform iOS \
   --cache-builds \
   --no-use-binaries

CURRENT_XCODE_VERSION=$(shell xcversion selected | head -1 | cut -d ' ' -f2)



## Targets ##
#

# default target
.PHONY: help
help:
	echo "help - show this information"
	echo "clean_all - clean everything including carthage"
	echo "xcode_check - select expected version of Xcode"
	echo "Carthage - carthage bootstrap"
	echo "update - carthage update"
	ceho "clean - clean the build"
	echo "test - run unit tests"

# clean everything including Carthage
.PHONY: clean_all
clean_all: clean
	@rm -rf Carthage

# xcode version check
.PHONY: xcode_check
xcode_check:
	if [ $(CURRENT_XCODE_VERSION) != $(XCODE_VERSION) ]; then xcversion select $(XCODE_VERSION); fi

# carthage bootstrap
#.PHONY: Carthage #This only needs to be phony on the build server
Carthage: xcode_check
	$(call carthage,bootstrap)

# carthage update (should not be run on the build server)
.PHONY: update
update: xcode_check
	$(call carthage,update)
	carting update

.PHONY: clean
clean:
xcodebuild \
	-project TheCollector.xcodeproj \
	-scheme TheCollector \
	-derivedDataPath derivedData \
	-configuration Debug \
	clean

.PHONY: test
test: Carthage
	xcodebuild \
	-project TheCollector.xcodeproj \
	-scheme TheCollector \
	-derivedDataPath derivedData \
	-configuration Debug \
	-destination "platform=iOS Simulator,name=iPhone X" \
	test
