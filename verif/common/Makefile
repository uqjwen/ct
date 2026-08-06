REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
ENVS := $(notdir $(patsubst %/module.json,%,$(wildcard $(REPO_ROOT)/verif/xx_lsu_*/module.json)))

.PHONY: preflight compile regress coverage

preflight:
	cd $(REPO_ROOT) && python3 verif/common/tools/preflight.py --all

compile:
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env compile; done

regress:
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env regress; done

coverage:
	@set -e; for env in $(ENVS); do $(MAKE) -C $(REPO_ROOT)/verif/$$env coverage; done
