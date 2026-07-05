SKILLS_DIR := $(HOME)/.claude/skills
SKILLS     := git-commit-message work-log frontend-audit

install:
	@mkdir -p $(SKILLS_DIR)
	@for skill in $(SKILLS); do \
		rm -rf $(SKILLS_DIR)/$$skill; \
		ln -sf $(CURDIR)/$$skill $(SKILLS_DIR)/$$skill; \
		echo "  installed $$skill → $(SKILLS_DIR)/$$skill"; \
	done

uninstall:
	@for skill in $(SKILLS); do \
		rm -rf $(SKILLS_DIR)/$$skill; \
		echo "  removed $$skill"; \
	done

update:
	git pull

.PHONY: install uninstall update
