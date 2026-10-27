# Troubleshooting
1.  ERROR: Started the whole project typing loose python code
    - Solution: Since I'm using `uv` as project manager, I initiated `uv init`.
2.  ERROR: Didn't assign `test_wordcount.py` to `tests` folder and `wordcount.py` to `src`. Upon transfering the files to their designated folders, pytest producing error.
    - Solution: changed `from wordcount import count_words` to `from textfile_wordcount_processor.wordcount import count_words`
3. `ERROR tests/test_handler.py - botocore.exceptions.NoRegionError: You must specify a region.` during `test_handler.py` pytest
    - Solution: `handler.py` automatically locates AWS region, local test needs `os.environ["AWS_DEFAULT_REGION"] = "us-east-1"` as a placeholder.
4. `Error: Failed to query available provider packages` during `terraform init`
    - Solution: 
        - `terraform providers` Check required provider config
        - `https://registry.terraform.io/.well-known/terraform.json` check network connectivity to registry
        - Maybe its just a temporary network timeout