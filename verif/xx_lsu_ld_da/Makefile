ENV_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
REPO_ROOT := $(abspath $(ENV_DIR)/../..)
BUILD_DIR := $(ENV_DIR)/build
LOG_DIR := $(BUILD_DIR)/logs
SIMV := $(BUILD_DIR)/simv
TEST ?= tc_da_cache_data
SEED ?= 1
VCS ?= vcs
URG ?= urg
CM := line+cond+fsm+tgl+branch+assert
VCS_FLAGS ?= -full64 -sverilog -timescale=1ns/1ps -debug_access+all -kdb -lca +vcs+lic+wait -cm $(CM)

.PHONY: preflight generate compile run regress coverage clean

preflight:
	cd $(REPO_ROOT) && python3 verif/common/tools/preflight.py --env xx_lsu_ld_da

generate:
	cd $(REPO_ROOT) && python3 verif/common/tools/gen_env.py --env xx_lsu_ld_da

compile: preflight
	@command -v $(VCS) >/dev/null 2>&1 || { echo "ERROR: Synopsys VCS not found; set VCS=/path/to/vcs on a licensed host."; exit 127; }
	mkdir -p $(BUILD_DIR) $(LOG_DIR)
	cd $(REPO_ROOT) && $(VCS) $(VCS_FLAGS) -f verif/xx_lsu_ld_da/filelist.f -top xx_lsu_ld_da_tb -o $(SIMV) -l $(LOG_DIR)/compile.log

run: compile
	$(SIMV) +TEST=$(TEST) +ntb_random_seed=$(SEED) -cm $(CM) -cm_dir $(BUILD_DIR)/cm/$(TEST).vdb -l $(LOG_DIR)/$(TEST).log

regress: compile
	mkdir -p $(BUILD_DIR)/cm $(LOG_DIR)
	@set -e; while IFS= read -r test; do case "$$test" in ""|"#"*) continue ;; esac; echo "RUN $$test"; $(SIMV) +TEST=$$test +ntb_random_seed=$(SEED) -cm $(CM) -cm_name $$test -cm_dir $(BUILD_DIR)/cm/$$test.vdb -l $(LOG_DIR)/$$test.log; done < $(ENV_DIR)/tests.list

coverage: regress
	@command -v $(URG) >/dev/null 2>&1 || { echo "ERROR: Synopsys URG not found; set URG=/path/to/urg."; exit 127; }
	$(URG) -full64 -dir $(BUILD_DIR)/cm/*.vdb -report $(BUILD_DIR)/urg_report -format both -dbname xx_lsu_ld_da_merged -l $(LOG_DIR)/urg.log

clean:
	rm -rf $(BUILD_DIR) $(REPO_ROOT)/csrc $(REPO_ROOT)/simv.daidir $(REPO_ROOT)/ucli.key
