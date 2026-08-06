REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
ENVS := $(notdir $(patsubst %/module.json,%,$(wildcard $(REPO_ROOT)/verif/xx_lsu_*/module.json)))
VCS ?= vcs
URG ?= urg

.PHONY: preflight compile regress coverage

preflight:
	cd $(REPO_ROOT) && python3 verif/common/tools/preflight.py --all

compile: preflight
	@command -v $(VCS) >/dev/null 2>&1 || { echo "ERROR: Synopsys VCS not found; set VCS=/path/to/vcs on a licensed host."; exit 127; }
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env compile VCS=$(VCS); done

regress:
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env regress VCS=$(VCS); done

coverage:
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env coverage VCS=$(VCS) URG=$(URG); done
