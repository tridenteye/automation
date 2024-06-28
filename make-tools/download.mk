REPO_SERVER ?= https://reposerver.com
FILE_PATH ?= Folder/Sub-folder

FILE_NAMES := file1.tgz file2.tar.gz
REPO_USER ?= 
REPO_PASS ?= 

.PHONY: download-curl download-wget checksum-verification

download-curl:
    @for file in $(FILE_NAMES); do \
		echo "################### Downloading $$file... ###################"; \
        curl -sSL --progress-bar -u $(REPO_USER):$(REPO_PASS) -o $$file $(REPO_SERVER)/$(FILE_PATH)/$$file; \
		$(MAKE) checksum-verification FILE=$$file; \
    done
            
download-wget:
    @for file in $(FILE_NAMES); do \
		echo "################### Downloading $$file... ###################"; \
        wget -q --show-progress --user=$(REPO_USER) --password=$(REPO_PASS) -O $$file $(REPO_SERVER)/$(FILE_PATH)/$$file; \
		$(MAKE) checksum-verification file=$$file; \
    done

checksum-verification:
	@remote_checksum=$$(curl -s -u $(REPO_USER):$(REPO_PASS) $(REPO_SERVER)/$(FILE_PATH)/$$file | sha256sum | cut -d' ' -f1); \
	dl_checksum=$$(sha256sum $$file | cut -d' ' -f1); \
		if [ "$$remote_checksum" != "$$dl_checksum" ]; then \
			echo "Checksum verification failed for $$file"; \
			exit 1; \
		fi